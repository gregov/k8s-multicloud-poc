# Bot coding hint: 
```
PODNAME=$(kubectl get pods --namespace rocketchat -l "app.kubernetes.io/name=hubot-rocketchat" -o jsonpath='{ .items[0].metadata.name }')
kubectl cp rocketchat/k8sfederation.coffee rocketchat/$PODNAME:/home/hubot/scripts/k8sfederation.coffee
```

then say "hubot reload" in Rocketchat