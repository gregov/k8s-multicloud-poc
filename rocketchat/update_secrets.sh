#!/usr/bin/bash

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: my-rocketchat-mongodb
  labels:
    app: mongodb        
type: Opaque
data:
  mongodb-root-password:  "$(echo $MONGODBROOTPASSWORD | base64)"
  mongodb-password:  "$(echo $MONGODBPASSWORD | base64)"
  mongodb-replica-set-key: "ZjBXV3ZWVkswMQ=="
---
apiVersion: v1
kind: Secret
metadata:
  name: my-rocketchat-rocketchat
  labels:
    app.kubernetes.io/name: rocketchat
    app.kubernetes.io/instance: my-rocketchat
type: Opaque
data:
  mongo-uri: $(echo "mongodb://rocketchat:$MONGODBPASSWORD@my-rocketchat-mongodb:27017/rocketchat" | base64)
  mongo-oplog-uri: $(echo "mongodb://root:$MONGODBROOTPASSWORD@my-rocketchat-mongodb:27017/local?replicaSet=rs0&authSource=admin" | base64)
EOF
