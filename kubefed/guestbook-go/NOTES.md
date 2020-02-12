# Install

brew install wget
wget https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/redis-master-controller.json
wget https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/redis-master-service.json
wget https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/redis-slave-controller.json
wget https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/redis-slave-service.json
wget https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/guestbook-controller.json
wget https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/guestbook-service.json


kubectl --context arctiq-ext-mission-gcp apply -f redis-master-controller.json
kubectl --context arctiq-ext-mission-gcp apply -f redis-master-service.json
kubectl --context arctiq-ext-mission-gcp apply -f redis-slave-controller.json
kubectl --context arctiq-ext-mission-gcp apply -f redis-slave-service.json
kubectl --context arctiq-ext-mission-gcp apply -f guestbook-controller.json
kubectl --context arctiq-ext-mission-gcp apply -f guestbook-service.json

kubectl --context arctiq-ext-mission-aws apply -f redis-master-controller.json
kubectl --context arctiq-ext-mission-aws apply -f redis-master-service.json
kubectl --context arctiq-ext-mission-aws apply -f redis-slave-controller.json
kubectl --context arctiq-ext-mission-aws apply -f redis-slave-service.json
kubectl --context arctiq-ext-mission-aws apply -f guestbook-controller.json
kubectl --context arctiq-ext-mission-aws apply -f guestbook-service.json

kubectl --context arctiq-ext-mission-azure apply -f redis-master-controller.json
kubectl --context arctiq-ext-mission-azure apply -f redis-master-service.json
kubectl --context arctiq-ext-mission-azure apply -f redis-slave-controller.json
kubectl --context arctiq-ext-mission-azure apply -f redis-slave-service.json
kubectl --context arctiq-ext-mission-azure apply -f guestbook-controller.json
kubectl --context arctiq-ext-mission-azure apply -f guestbook-service.json


kubectl --context arctiq-ext-mission-gcp get services -o wide
kubectl --context arctiq-ext-mission-aws get services -o wide
kubectl --context arctiq-ext-mission-azure get services -o wide



NB:
	AWS requires to open the port (maybe ?)
	GCP works out of the box
	Azure takes time to provision the ELB


# Cleanup

kubectl --context arctiq-ext-mission-aws delete service guestbook
kubectl --context arctiq-ext-mission-aws delete replicationcontrollers guestbook
kubectl --context arctiq-ext-mission-aws delete service redis-slave
kubectl --context arctiq-ext-mission-aws delete replicationcontrollers redis-slave
kubectl --context arctiq-ext-mission-aws delete service redis-master
kubectl --context arctiq-ext-mission-aws delete replicationcontrollers redis-master

kubectl --context arctiq-ext-mission-azure delete service guestbook
kubectl --context arctiq-ext-mission-azure delete replicationcontrollers guestbook
kubectl --context arctiq-ext-mission-azure delete service redis-slave
kubectl --context arctiq-ext-mission-azure delete replicationcontrollers redis-slave
kubectl --context arctiq-ext-mission-azure delete service redis-master
kubectl --context arctiq-ext-mission-azure delete replicationcontrollers redis-master

kubectl --context arctiq-ext-mission-gcp delete service guestbook
kubectl --context arctiq-ext-mission-gcp delete replicationcontrollers guestbook
kubectl --context arctiq-ext-mission-gcp delete service redis-slave
kubectl --context arctiq-ext-mission-gcp delete replicationcontrollers redis-slave
kubectl --context arctiq-ext-mission-gcp delete service redis-master
kubectl --context arctiq-ext-mission-gcp delete replicationcontrollers redis-master