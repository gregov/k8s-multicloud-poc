# Installation

## Prerequisite, creds for the service to modify route53
```
aws iam create-policy --policy-name external-dns-aws-policy --policy-document file://external-dns/external-dns-aws-policy.json
{
    "Policy": {
        "PolicyName": "external-dns-aws-policy",
        "PolicyId": "ANPASMIOBHI7JVGC3YHLO",
        "Arn": "arn:aws:iam::163775068734:policy/external-dns-aws-policy",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "PermissionsBoundaryUsageCount": 0,
        "IsAttachable": true,
        "CreateDate": "2020-02-13T18:03:40+00:00",
        "UpdateDate": "2020-02-13T18:03:40+00:00"
    }
}
aws iam create-user --user-name external-dns-global 
{
    "User": {
        "Path": "/",
        "UserName": "external-dns-global",
        "UserId": "AIDASMIOBHI7FKADIQDCQ",
        "Arn": "arn:aws:iam::163775068734:user/external-dns-global",
        "CreateDate": "2020-02-13T18:15:46+00:00"
    }
}
aws iam create-access-key --user-name external-dns-global
{
    "AccessKey": {
        "UserName": "external-dns-global",
        "AccessKeyId": "AKIASMIOBHI7MJG3T2N4",
        "Status": "Active",
        "SecretAccessKey": "***",
        "CreateDate": "2020-02-13T18:16:23+00:00"
    }
}
aws iam attach-user-policy --user-name external-dns-global --policy-arn arn:aws:iam::163775068734:policy/external-dns-aws-policy
```


## clusterrolebindings is not federated by default (known bug)
https://github.com/kubernetes-sigs/kubefed/pull/1162
kubefedctl enable clusterrolebindings.rbac.authorization.k8s.io


## install the secret

## deploy the federated manifest

```

## Details on the routing

https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-values-geo.html


## To delete external-dns
```
kubectl config use-context arctiq-ext-mission-azure
kubectl delete -f secrets/external-dns-azure.yml
kubectl config use-context arctiq-ext-mission-aws
kubectl delete -f secrets/external-dns-aws.yml
kubectl config use-context arctiq-ext-mission-gcp
kubectl delete -f secrets/external-dns-gcp.yml
```

## Caveats
there is no current way to define the default Geolocation, 
external-dns expects a field of length > 2 but AWS wants '*'

So for now external-dns maintains an A record per cluster, the loadbalancing is done manually via AWS console using aliases
