# Installation

```
kubectl apply -f kubefed/tiller-rbac.yml
helm init --service-account tiller --wait

helm install stable/rocketchat --name rocketchat --namespace rocketchat --values rocketchat/rocketchat.values.yml --set extraEnv="- name: ADMIN_USERNAME \n    value: admin\n  - name: ADMIN_PASS\n    value: $(ROCKETCHAT_PASSWORD)" --set mongodbRootPassword=$(ROCKETCHAT_MONGO_ROOTPASSWORD) --mongodbPassword=$(ROCKETCHAT_MONGO_PASSWORD) --wait

bash rocketchat/create_user.sh
bash rocketchat/install_hubot.sh
```

Bot coding hint: 
```
PODNAME=$(kubectl get pods --namespace rocketchat -l "app.kubernetes.io/name=hubot-rocketchat" -o jsonpath='{ .items[0].metadata.name }')
kubectl cp rocketchat/k8sfederation.coffee rocketchat/$PODNAME:/home/hubot/scripts/k8sfederation.coffee
```

then say "hubot reload" in Rocketchat