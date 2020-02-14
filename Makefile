.DEFAULT_GOAL:=help
SHELL:=/usr/bin/env bash

GCP_REGION=australia-southeast1
AWS_REGION=sa-east-1
FEDERATION_HOST=arctiq-ext-mission-aws

##@ Creation
create-clusters:  ## Create the 3 clusters
	cd terraform ;\
	terraform init ;\
	terraform apply -auto-approve ;\
	terraform output kube_config > ../.kube_config_azure
	# Kubeconfig for aws
	rm .kube_config_*
	aws eks update-kubeconfig --region $(AWS_REGION) --name arctiq-ext-mission-aws --alias arctiq-ext-mission-aws --kubeconfig .kube_config_aws
	bash terraform/fix-eks-kubectl-config.sh .kube_config_aws
	# Kubeconfig for gcp
	KUBECONFIG=.kube_config_gcp gcloud container clusters get-credentials arctiq-ext-mission-gcp --region $(GCP_REGION)
	sed -i .bak s/gke_arctiq-ext-.*-ext-mission-gcp/arctiq-ext-mission-gcp/  .kube_config_gcp
	# Merge all kubeconfigs
	KUBECONFIG=.kube_config_aws:.kube_config_azure:.kube_config_gcp kubectl config view --raw > ~/.kube/config

##@ Federation
federation-host: ## Initialise the federation host
	kubectl config use-context $(FEDERATION_HOST)
	kubectl apply -f kubefed/tiller-rbac.yml
	helm init --service-account tiller --wait
	helm repo add kubefed-charts https://raw.githubusercontent.com/kubernetes-sigs/kubefed/master/charts
	helm repo update
	helm install  kubefed-charts/kubefed --name kubefed --version=v0.1.0-rc6 --namespace kube-federation-system --wait
	kubectl apply -f kubefed/federated-namespace.yml

add-federation-members: ## Add all federation members
	kubefedctl join cluster-federation-azure --cluster-context arctiq-ext-mission-azure --host-cluster-context $(FEDERATION_HOST) -v 2
	kubefedctl join cluster-federation-aws --cluster-context arctiq-ext-mission-aws --host-cluster-context $(FEDERATION_HOST) -v 2
	kubefedctl join cluster-federation-gcp --cluster-context arctiq-ext-mission-gcp --host-cluster-context $(FEDERATION_HOST) -v 2

remove-federation-members: ## Remove all federation members
	kubefedctl unjoin cluster-federation-azure --cluster-context arctiq-ext-mission-azure --host-cluster-context $(FEDERATION_HOST) -v 2
	kubefedctl unjoin cluster-federation-aws --cluster-context arctiq-ext-mission-aws --host-cluster-context $(FEDERATION_HOST) -v 2
	kubefedctl unjoin cluster-federation-gcp --cluster-context arctiq-ext-mission-gcp --host-cluster-context $(FEDERATION_HOST) -v 2

##@ Services
install-external-dns:  ## Install external dns
	kubectl apply -f external-dns/external-dns-federated.yml
	bash external-dns/update_federated_secrets.sh

remove-external-dns:  ## Install external dns
	kubectl delete -f external-dns/external-dns-federated.yml

install-rocketchat:  ## Install Rocketchat
	kubectl apply -f rocketchat/rocketchat.yml
	bash rocketchat/update_secrets.sh

remove-rocketchat:  ## Install Rocketchat
	kubectl delete -f rocketchat/rocketchat.yml

install-docker-secret: ## Install local docker secrets
	kubectl --context arctiq-ext-mission-aws create secret docker-registry regcred --docker-server=docker.pkg.github.com --docker-username=$(GITHUB_USERNAME) --docker-password=$(GITHUB_PACKAGE_ACCESS_TOKEN) --docker-email=$(GITHUB_EMAIL) -n global
	kubectl --context arctiq-ext-mission-azure create secret docker-registry regcred --docker-server=docker.pkg.github.com --docker-username=$(GITHUB_USERNAME) --docker-password=$(GITHUB_PACKAGE_ACCESS_TOKEN) --docker-email=$(GITHUB_EMAIL) -n global
	kubectl --context arctiq-ext-mission-gcp create secret docker-registry regcred --docker-server=docker.pkg.github.com --docker-username=$(GITHUB_USERNAME) --docker-password=$(GITHUB_PACKAGE_ACCESS_TOKEN) --docker-email=$(GITHUB_EMAIL) -n global

remove-docker-secret: ## Install local docker secrets
	kubectl --context arctiq-ext-mission-aws delete secret regcred -n global
	kubectl --context arctiq-ext-mission-azure delete secret regcred -n global
	kubectl --context arctiq-ext-mission-gcp delete secret regcred -n global

##@ Application
deploy:  ## Deploy the guestbook across all clusters
	kubectl apply -f guestbook-go/guestbook-federated.yml

undeploy:  ## Deploy the guestbook across all clusters
	kubectl delete -f guestbook-go/guestbook-federated.yml

##@ Destructions
destroy-clusters:  ## Destroy clusters
	cd terraform; \
	terraform destroy -auto-approve

##@ Helpers
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


