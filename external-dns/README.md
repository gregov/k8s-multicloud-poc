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
--set aws.credentials.secretKey=*** \
--set txtOwnerId=ZR42SNG7WXR4K --set domainFilters[0]=global.earlyfrench.ca \
stable/external-dns
```

then copy the generated manifest to secret/external-dns.yml (secrets are in plain text)

## Manually applying the manifest everywhere
```
kubectl config use-context arctiq-ext-mission-azure
kubectl apply -f secret/external-dns.yml
kubectl config use-context arctiq-ext-mission-aws
kubectl apply -f secret/external-dns.yml
kubectl config use-context arctiq-ext-mission-gcp
kubectl apply -f secret/external-dns.yml
```

## Todo take care of the routing