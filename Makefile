.DEFAULT_GOAL:=help
SHELL:=/usr/bin/env bash

##@ Creation
create-aws-cluster:  ## Create EKS on AWS
	terraform init aws
	terraform apply -state=aws/terraform.state -auto-approve aws
	aws eks update-kubeconfig --name arctiq-ext-mission-aws --alias arctiq-ext-mission-aws --kubeconfig ~/.kube/config_aws
	# Fix config file syntax
	# /!\ Untested on other platforms than macOs
	bash aws/fix-kubectl-config.sh ~/.kube/config_aws

create-azure-cluster:  ## Create AKS on Azure
	terraform init azure
	terraform apply -state=azure/terraform.state -var-file=secrets/azure.tfvars -auto-approve azure
	terraform output -state=azure/terraform.state kube_config > ~/.kube/config_azure

create-gcp-cluster:   ## Create GKS on GCP
	terraform init gcp
	terraform apply -state=gcp/terraform.state -var-file=gcp/variables.tfvars -auto-approve gcp
	KUBECONFIG=~/.kube/config_gcp gcloud container clusters get-credentials arctiq-ext-missi-1581512285377-cluster --region europe-north1
	sed  s/gke_arctiq-ext-.*-cluster/arctiq-ext-mission-gcp/ -i  ~/.kube/config_gcp

create-all-clusters: create-aws-cluster create-azure-cluster create-gcp-cluster ## Create all clustes

##@ Federation
federation-host: ## Initialise the federation host
	export KUBECONFIG=~/.kube/config_aws:~/.kube/config_gcp:~/.kube/config_azure
	kubectl config use-context arctiq-ext-mission-aws
	kubectl apply -f kubefed/tiller-rbac.yml
	helm init --service-account tiller --wait
	helm repo add kubefed-charts https://raw.githubusercontent.com/kubernetes-sigs/kubefed/master/charts
	helm repo update
	helm install  kubefed-charts/kubefed --name kubefed --version=v0.1.0-rc6 --namespace kube-federation-system --wait
	kubectl apply -f kubefed/federated-namespace.yml

add-federation-members: ## Add all federation members
	kubefedctl join cluster-federation-azure --cluster-context arctiq-ext-mission-azure --host-cluster-context minikube -v 2
	kubefedctl join cluster-federation-aws --cluster-context arctiq-ext-mission-aws --host-cluster-context minikube -v 2
	kubefedctl join cluster-federation-gcp --cluster-context arctiq-ext-mission-gcp --host-cluster-context minikube -v 2

remove-federation-members: ## Remove all federation members
	kubefedctl unjoin cluster-federation-azure --cluster-context arctiq-ext-mission-azure --host-cluster-context minikube -v 2
	kubefedctl unjoin cluster-federation-aws --cluster-context arctiq-ext-mission-aws --host-cluster-context minikube -v 2
	kubefedctl unjoin cluster-federation-gcp --cluster-context arctiq-ext-mission-gcp --host-cluster-context minikube -v 2

##@ Application
deploy:  ## Deploy the guestbook across all clusters
	kubectl apply -f guestbook-go/guestbook-federated.yml

##@ Destructions
destroy-aws-cluster:  ## Destroy AWS cluster
	terraform destroy -auto-approve  -state=gcp/terraform.state aws

destroy-azure-cluster:  ## Destroy Azure cluster
	terraform destroy -var-file=secrets/azure.tfvars -auto-approve  -state=azure/terraform.state azure

destroy-gcp-cluster:  ## Destroy GCP cluster
	terraform destroy -var-file=variables.tfvars -auto-approve  -state=gcp/terraform.state gcp

destroy-all-clusters: destroy-aws-cluster destroy-azure-cluster destroy-gcp-cluster ## Destroy all clustes

##@ Helpers
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


