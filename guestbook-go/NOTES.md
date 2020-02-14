# Install
```
kubectl apply -f guestbook-go/modified/guestbook-federated.yml
```

# Cleanup
```
kubectl delete -f guestbook-go/modified/guestbook-federated.yml
```


# About the docker tocken

A Personal access token has to be used as the password. 
Permissions should be at least: repo/public_repo + read:packages


```
 kubectl --context arctiq-ext-mission-aws create secret docker-registry regcred --docker-server=docker.pkg.github.com --docker-username=$GITHUB_USERNAME --docker-password=$GITHUB_PACKAGE_ACCESS_TOKEN
 
 kubectl --context arctiq-ext-mission-azure create secret docker-registry regcred --docker-server=docker.pkg.github.com --docker-username=$GITHUB_USERNAME --docker-password=$GITHUB_PACKAGE_ACCESS_TOKEN
   
 kubectl --context arctiq-ext-mission-gcp create secret docker-registry regcred --docker-server=docker.pkg.github.com --docker-username=$GITHUB_USERNAME --docker-password=$GITHUB_PACKAGE_ACCESS_TOKEN
```
kubectl create secret docker-registry regcred --docker-server=docker.pkg.github.com --docker-username=$GITHUB_USERNAME --docker-password=$GITHUB_PACKAGE_ACCESS_TOKEN