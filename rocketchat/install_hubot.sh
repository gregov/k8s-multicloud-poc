cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: deployment-manager
  namespace: rocketchat
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: deployment-manager
rules:
- apiGroups: ["types.kubefed.io"]
  resources: ["federateddeployments", "federatedservices"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: deployment-manager
roleRef:
  kind: ClusterRole
  name: deployment-manager
  apiGroup: ""
subjects:
  - kind: ServiceAccount
    name: deployment-manager    
    namespace: rocketchat
EOF

cat <<EOF2 | kubectl apply -f -
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hubot-rocketchat
  labels:
    app.kubernetes.io/name: hubot-rocketchat
  namespace: rocketchat
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: hubot-rocketchat
  template:
    metadata:
      name: hubot-rocketchat
      labels:
        app.kubernetes.io/name: hubot-rocketchat
    spec:
      serviceAccountName: deployment-manager
      containers:
      - image: rocketchat/hubot-rocketchat
        name: hubot-rocketchat
        env:
        - name: ROCKETCHAT_URL
          value: rocketchat-rocketchat
        - name: ROCKETCHAT_ROOM
          value: general
        - name: RESPOND_TO_DM
          value: "true"
        - name: ROCKETCHAT_USER
          value: hubot
        - name: ROCKETCHAT_PASSWORD
          value: $HUBOT_PASSWORD
        - name: ROCKETCHAT_AUTH
          value: password
        - name: BOT_NAME
          value: hubot
        - name: HUBOT_LOG_LEVEL
          value: debug
        - name: EXTERNAL_SCRIPTS
          value: hubot-help,hubot-bofh,hubot-reload-scripts
EOF2

echo "Waiting for Hubot pod to be in a ready state"
while [[ $(kubectl get pods --namespace rocketchat -l "app.kubernetes.io/name=hubot-rocketchat" -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do 
  echo -n "." && sleep 3
done

PODNAME=$(kubectl get pods --namespace rocketchat -l "app.kubernetes.io/name=hubot-rocketchat" -o jsonpath='{ .items[0].metadata.name }')
kubectl cp rocketchat/k8sfederation.coffee rocketchat/$PODNAME:/home/hubot/scripts/k8sfederation.coffee