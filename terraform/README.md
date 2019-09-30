### Terraform

## Prerequisites

- Terraform v0.12
- S3 Bucket
- Dynamo table with string key `LockID`
## Deploy your environment [dev,qa,prod]

Make sure that your backend configuration files are set properly, these files are located inside the config folder, make sure that the bucket and dynamo table exist, the dynamo table must have the string key `LockID`.

Modify your environment parameters on the tfvars file inside the config folder, make sure that your vpc CIDR does not overlaps between environments, add the name of your pem key to the worker map variable.

### Create the base infrastructure

The base infrastructure stack contains all the resources to setup the networking, IAM roles policies and roles.

Run the following commands to create/plan/update the base_infra stack (staging as example):

```
cd base_infra
terraform init
export env=staging
terraform workspace select ${env} || terraform workspace new ${env}
terraform apply -var-file=../config/${env}.tfvars
```

To destroy the base_infra stack:

```
cd base_infra
export env=staging
terraform workspace select ${env}
terraform destroy -var-file=config/${env}.tfvars

```
### Create the EKS cluster

Creates the EKS cluster with an ASG for worker nodes. Also adds kube2iam, kubernetes dashboard etc.

```
cd eks
terraform init
env=staging
terraform workspace select ${env} || terraform workspace new ${env}
terraform apply -var-file=config/${env}.tfvars
```

To destroy the cluster:

```
cd eks
env=staging
terraform workspace select ${env}
terraform destroy -var-file=config/${env}.tfvars

```
