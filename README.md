README.md

To setup the clusters, follow instructions

* [AWS EKS](aws/README.md)
* [Azure AKS](azure/README.md)
* [GCP GKS](gcp/README.md)

```
export KUBECONFIG="$HOME/.kube/config_aws:$HOME/.kube/config_gcp:$HOME/.kube/config_azure"
kubectl config get-contexts
```
The three clusters should be present

We will be using AWS to be the federation host

* [Installing the federation](kubefed/README.md)