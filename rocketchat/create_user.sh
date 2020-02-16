kubectl port-forward --namespace rocketchat $(kubectl get pods --namespace rocketchat -l "app.kubernetes.io/name=rocketchat,app.kubernetes.io/instance=rocketchat" -o jsonpath='{ .items[0].metadata.name }') 8888:3000 &
PROC_ID=$!

echo "Waiting for Rocketchat to answer on 8888..."

while ! curl --silent --output /dev/null --connect-timeout 5 -s http://localhost:8888; do   
  sleep 1
done

echo "Rocketchat launched"

python3 rocketchat/create_user.py -r http://localhost:8888 -ap $ROCKETCHAT_PASSWORD -bp $HUBOT_PASSWORD

# Terminate the tunnel
kill -TERM $PROC_ID