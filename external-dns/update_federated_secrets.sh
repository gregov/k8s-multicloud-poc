#!/usr/bin/bash

cat <<EOF | kubectl apply -f -
apiVersion: types.kubefed.io/v1beta1
kind: FederatedSecret
metadata:
  name: external-dns-global
  namespace: global
spec:
  placement:
    clusters:
    - name: cluster-federation-aws
    - name: cluster-federation-azure
    - name: cluster-federation-gcp
  template:
    metadata:
      name: external-dns-global
      labels: 
        app.kubernetes.io/name: external-dns
    type: Opaque
    data:
      credentials: $(base64 secrets/aws-external-dns.conf)
      config: "Cltwcm9maWxlIGRlZmF1bHRdCnJlZ2lvbiA9IHNhLWVhc3QtMQo="
EOF
