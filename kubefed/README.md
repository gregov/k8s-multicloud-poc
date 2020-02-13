# Installing the federation on AWS
```
kubectl config use-context arctiq-ext-mission-aws
```


1. Setting up a federation
a. Install the server side
```
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
EOF

```

```
helm init --service-account tiller --wait
```

# you can check that tiller is running by typing
```
kubectl get pods -n kube-system
```

```
helm repo add kubefed-charts https://raw.githubusercontent.com/kubernetes-sigs/kubefed/master/charts
helm repo update
helm install  kubefed-charts/kubefed --name kubefed  --version=v0.1.0-rc6 --namespace kube-federation-system
```

b. Install the federation client
```
tar -zxvf ~/Downloads/kubefedctl-0.1.0-rc6-darwin-amd64.tgz
mv kubefedctl /usr/local/bin/
```

2. Associate member clusters
/!\ if not working properly the kubectl config might have to be altered

```
kubefedctl join cluster-federation-azure --cluster-context arctiq-ext-mission-azure --host-cluster-context arctiq-ext-mission-aws -v 2
kubefedctl join cluster-federation-aws --cluster-context arctiq-ext-mission-aws --host-cluster-context arctiq-ext-mission-aws -v 2
kubefedctl join cluster-federation-gcp --cluster-context arctiq-ext-mission-gcp --host-cluster-context arctiq-ext-mission-aws -v 2
```
 
At this point the global cluster should be showing the three clusters
```
kubectl -n kube-federation-system get kubefedclusters
```

3. Install the replicated namespace
kubectl apply -f kubefed/templates/LocalNamespace.yml
kubectl apply -f kubefed/templates/FederatedNamespace.yml

4. Deploy something federated
kubectl apply -f kubefed/templates/FederatedDeployment.yml

Or 

kubectl apply -f kubefed/guestbook-go/guestbook-federated.yml




# Uninstall

kubefedctl unjoin cluster-federation-azure --cluster-context arctiq-ext-mission-azure --host-cluster-context minikube -v 2
kubefedctl unjoin cluster-federation-aws --cluster-context arctiq-ext-mission-aws --host-cluster-context minikube -v 2
kubefedctl unjoin cluster-federation-gcp --cluster-context arctiq-ext-mission-gcp --host-cluster-context minikube -v 2
