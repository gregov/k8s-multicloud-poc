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

4. Install EKS
```
terraform apply
aws eks update-kubeconfig --name arctiq-ext-mission-aws
```
/!\ some config cleanup is required here, see https://www.nickaws.net/aws/elixir/2019/09/02/Federation-and-EKS.html, for example all the names have to be simplified and urls have to be lower case only


# Notes
Max pods per node depends on instance size
see:
https://github.com/awslabs/amazon-eks-ami/blob/master/files/eni-max-pods.txt