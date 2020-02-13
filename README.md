README.md

To setup the clusters, use the Makefile

```
Usage:
  make <target>

Creation
  create-aws-cluster  Create EKS on AWS
  create-azure-cluster  Create AKS on Azure
  create-gcp-cluster  Create GKS on GCP
  create-all-clusters  Create all clustes

Federation
  federation-host  Initialise the federation host
  add-federation-members  Add all federation members
  remove-federation-members  Remove all federation members

Application
  deploy           Deploy the guestbook across all clusters

Destructions
  destroy-aws-cluster  Destroy AWS cluster
  destroy-azure-cluster  Destroy Azure cluster
  destroy-gcp-cluster  Destroy GCP cluster
  destroy-all-clusters  Destroy all clustes

Helpers
  help             Display this help
```

Nb. a "secrets/" folder is necessary and has not been included in this repo for obvious reasons