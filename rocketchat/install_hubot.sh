cat <<EOF | kubectl apply -f -
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
          value: hubot-help,hubot-seen,hubot-links,hubot-diagnostics,hubot-google,hubot-reddit,hubot-bofh,hubot-bookmark,hubot-shipit,hubot-maps
EOF