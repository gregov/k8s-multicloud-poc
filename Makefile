.DEFAULT_GOAL:=help
SHELL:=/usr/bin/env bash

GCP_REGION=australia-southeast1
AWS_REGION=sa-east-1
PROJECT_NAME=arctiq-ext-mission
FEDERATION_HOST=gcp
FEDERATION_MEMBERS=aws gcp azure

##@ Creation
.PHONY: create-clusters
create-clusters:  ## Create the 3 clusters
	cp ~/.kube/config ~/.kube/config.bak
	rm .kube_config_*
	cd terraform ;\
	terraform init ;\
	terraform apply -auto-approve ;\
	terraform output kube_config > ../.kube_config_azure
	# Kubeconfig for aws
	aws eks update-kubeconfig --region $(AWS_REGION) --name $(PROJECT_NAME)-aws --alias $(PROJECT_NAME)-aws --kubeconfig .kube_config_aws
	bash terraform/fix-eks-kubectl-config.sh .kube_config_aws
	# Kubeconfig for gcp
	KUBECONFIG=.kube_config_gcp gcloud container clusters get-credentials $(PROJECT_NAME)-gcp --region $(GCP_REGION)
	sed -i .bak s/gke_arctiq-ext-.*-ext-mission-gcp/$(PROJECT_NAME)-gcp/  .kube_config_gcp
	# Merge all kubeconfigs
	KUBECONFIG=.kube_config_aws:.kube_config_azure:.kube_config_gcp kubectl config view --raw > ~/.kube/config

##@ Federation
.PHONY: federation-host
federation-host:  ## Initialise the federation host
	kubectl config use-context $(PROJECT_NAME)-$(FEDERATION_HOST)
	kubectl apply -f kubefed/tiller-rbac.yml
	helm init --service-account tiller --wait
	helm repo add kubefed-charts https://raw.githubusercontent.com/kubernetes-sigs/kubefed/master/charts
	helm repo update
	helm install  kubefed-charts/kubefed --name kubefed --version=v0.1.0-rc6 --namespace kube-federation-system --wait
	kubectl apply -f kubefed/federated-namespace.yml

.PHONY: add-federation-members
add-federation-members:  ## Add all federation members
	for cluster in $(FEDERATION_MEMBERS); do\
		kubefedctl join cluster-federation-$$cluster --cluster-context $(PROJECT_NAME)-$$cluster \
	--host-cluster-context $(PROJECT_NAME)-$(FEDERATION_HOST) -v 2 ;\
	done

.PHONY: remove-federation-members
remove-federation-members:  ## Remove all federation members
	for cluster in $(FEDERATION_MEMBERS); do\
		kubefedctl unjoin cluster-federation-$$cluster --cluster-context $(PROJECT_NAME)-$$cluster \
	--host-cluster-context $(PROJECT_NAME)-$(FEDERATION_HOST) -v 2 ;\
	done

.PHONY: configure-clusters
configure-clusters: federation-host add-federation-members install-external-dns install-docker-secret ## Configure the federation and dns


##@ Services
.PHONY: install-external-dns
install-external-dns:  ## Install external dns
	kubefedctl enable clusterrolebindings.rbac.authorization.k8s.io
	kubectl apply -f external-dns/external-dns-federated.yml
	bash external-dns/update_federated_secrets.sh

.PHONY: remove-external-dns
remove-external-dns:  ## Install external dns
	kubectl delete -f external-dns/external-dns-federated.yml

.PHONY: install-docker-secret
install-docker-secret:  ## Install local docker secrets
	for cluster in $(FEDERATION_MEMBERS); do\
		kubectl --context $(PROJECT_NAME)-$$cluster create secret docker-registry regcred \
	--docker-server=docker.pkg.github.com --docker-username=$(GITHUB_USERNAME) \
	--docker-password=$(GITHUB_PACKAGE_ACCESS_TOKEN) --docker-email=$(GITHUB_EMAIL) -n global ;\
	done

.PHONY: remove-docker-secret
remove-docker-secret:  ## Install local docker secrets
	for cluster in $(FEDERATION_MEMBERS); do\
		kubectl --context $(PROJECT_NAME)-aws delete secret regcred -n global ;\
	done

##@ Application
.PHONY: deploy-rocketchat
deploy-rocketchat:  ## Install Rocketchat
	bash rocketchat/rocketchat_config.sh
	helm install stable/rocketchat -n rocketchat --namespace rocketchat --values=rocketchat_values.yml --wait
	rm rocketchat_values.yml
	bash rocketchat/create_user.sh
	bash rocketchat/install_hubot.sh

.PHONY: undeploy-rocketchat
undeploy-rocketchat:  ## Uninstall Rocketchat
	helm del --purge rocketchat
	kubectl delete deployment hubot-rocketchat -n rocketchat

.PHONY: deploy-guestbook
deploy-guestbook:  ## Deploy the guestbook across all clusters
	kubectl apply -f guestbook-go/guestbook-federated.yml

.PHONY: undeploy-guestbook
undeploy-guestbook:  ## Uninstall the guestbook across all clusters
	kubectl delete -f guestbook-go/guestbook-federated.yml

##@ Destructions
.PHONY: destroy-clusters
destroy-clusters:  ## Destroy clusters
	cd terraform; \
	terraform destroy -auto-approve
	mv ~/.kube/config.bak ~/.kube/config

##@ Utils
flush-dns-cache:  ## Flush dns cache
	sudo killall -HUP mDNSResponder; sleep 2; echo macOS DNS Cache Reset

##@ Helpers
.PHONY: help
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


