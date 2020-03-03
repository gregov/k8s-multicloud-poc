# Installation
1. Create IAM user via the console


2. Install AWS CLI
```
$ curl https://awscli.amazonaws.com/AWSCLIV2.pkg -o AWSCLIV2.pkg
$ sudo installer -pkg AWSCLIV2.pkg  -target /
$ aws configure
```

3. Test
```
$ aws iam get-user
```

## Notes
Max pods per node depends on instance size

see:
https://github.com/awslabs/amazon-eks-ami/blob/master/files/eni-max-pods.txt
