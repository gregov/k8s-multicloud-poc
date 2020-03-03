1. Create a free account

2. Create a project
-> You've successfully set up the project k8s-multicloud-poc (ID: arctiq-ext-missi-1581512285377)

3. Install gcloud tool
```
curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-280.0.0-darwin-x86_64.tar.gz  -o google-cloud-sdk-280.0.0-darwin-x86_64.tar.gz

shasum -a 256 google-cloud-sdk-280.0.0-darwin-x86_64.tar.gz

tar -zxvf google-cloud-sdk-280.0.0-darwin-x86_64.tar.gz

google-cloud-sdk/install.sh

rm google-cloud-sdk-280.0.0-darwin-x86_64.tar.gz
```

4. Initialize gcloud
```
gcloud init
```

5. Create a service account for Terraform

IAM > Service accounts

Grant "Storage Admin" and "Kubernetes Engine Admin"

Create a JSON key and save it in ../secrets/ as "account.json"

6. Grant the role editor to terraform account
```
export PROJECT=k8s-multicloud-poc
export SERVICE_ACCOUNT=terraform
gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:${SERVICE_ACCOUNT}@${PROJECT}.iam.gserviceaccount.com --role roles/editor
```
7. Enable Kubernetes Engine API
https://console.developers.google.com/apis/api/container.googleapis.com/overview?project=1016789487866
