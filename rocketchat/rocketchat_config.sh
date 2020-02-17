cat << EOF > rocketchat_values.yml
extraEnv:  |
  - name: ADMIN_USERNAME 
    value: admin
  - name: ADMIN_PASS
    value: $ROCKETCHAT_PASSWORD
mongodb:
  mongodbRootPassword: $ROCKETCHAT_MONGO_ROOTPASSWORD
  mongodbUsername: rocketchat
  mongodbPassword: $ROCKETCHAT_MONGO_PASSWORD
  mongodbDatabase: rocketchat
service:
  type: LoadBalancer
  annotations: {"external-dns.alpha.kubernetes.io/hostname":"rocketchat.global.earlyfrench.ca."}
EOF