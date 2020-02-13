# Installing the federation on AWS
```
kubectl config use-context arctiq-ext-mission-aws
```

1. Setting up a federation
a. Install the server side
```
kubectl apply -f tiller-rbac.yml
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
```
kubectl apply -f kubefed/federated-namespace.yml
```

4. Deploy something federated
```
kubectl apply -f guestbook-go/guestbook-federated.yml
```

# Uninstall

kubefedctl unjoin cluster-federation-azure --cluster-context arctiq-ext-mission-azure --host-cluster-context minikube -v 2
kubefedctl unjoin cluster-federation-aws --cluster-context arctiq-ext-mission-aws --host-cluster-context minikube -v 2
kubefedctl unjoin cluster-federation-gcp --cluster-context arctiq-ext-mission-gcp --host-cluster-context minikube -v 2
