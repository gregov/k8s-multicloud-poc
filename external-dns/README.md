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

## I will generate the manifest, because I don't want Tiller on the federation members
```
helm install --debug --dry-run --name external-dns-global \
--set provider=aws --set aws.zoneType=public --set aws.region=sa-east-1 \
--set aws.credentials.accessKey=AKIASMIOBHI7MJG3T2N4 \
--set aws.credentials.secretKey=IL/4*******************l6RD \
--set txtOwnerId=ZR42SNG7WXR4K --set domainFilters[0]=global.earlyfrench.ca 
--set image.tag=0.5.18 \
stable/external-dns
```

then copy the generated manifest to secrets/external-dns.yml (secrets are in plain text)
change the zone owner id for each target cluster

## Manually applying the manifest everywhere
```
kubectl config use-context arctiq-ext-mission-azure
kubectl apply -f secrets/external-dns-azure.yml
kubectl config use-context arctiq-ext-mission-aws
kubectl apply -f secrets/external-dns-aws.yml
kubectl config use-context arctiq-ext-mission-gcp
kubectl apply -f secrets/external-dns-gcp.yml
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
