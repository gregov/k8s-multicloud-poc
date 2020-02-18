README.md

![Architecture Overview](arctiq-ext-mission.png)


To setup the clusters, use the Makefile

```

Usage:
  make <target>

Creation
  create-clusters  Create the 3 clusters

Federation
  federation-host  Initialise the federation host
  add-federation-members  Add all federation members
  remove-federation-members  Remove all federation members

Services
  install-external-dns  Install external dns
  remove-external-dns  Install external dns
  install-docker-secret  Install local docker secrets
  remove-docker-secret  Install local docker secrets

Application
  deploy-rocketchat  Install Rocketchat
  undeploy-rocketchat  Uninstall Rocketchat
  deploy-guestbook  Deploy the guestbook across all clusters
  undeploy-guestbook  Uninstall the guestbook across all clusters

Destructions
  destroy-clusters  Destroy clusters

Helpers
  help             Display this help
```

Nb. a "secrets/" folder is necessary and has not been included in this repo for obvious reasons