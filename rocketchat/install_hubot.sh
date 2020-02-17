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
  namespace: rocketchat
  name: deployment-manager
rules:
- apiGroups: ["", "extensions", "apps", "types.kubefed.io"]
  resources: ["*"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"] # You can also use ["*"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: deployment-manager
  namespace: rocketchat
roleRef:
  kind: ClusterRole
  name: deployment-manager
  apiGroup: ""
subjects:
  - kind: ServiceAccount
    name: deployment-manager
    namespace: kube-system
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
      # serviceAccountName: deployment-manager
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
          value: hubot-help,hubot-kubernetes,hubot-bofh
EOF2