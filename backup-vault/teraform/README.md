# AWS Backup Vault Terraform Configuration

To create or update the AWS config, Terraform must be run from a local machine, as there is currently no GitHub Action set up for this.

The following commands should be used as a suggestion for the process:

```shell
aws sso login --sso-session PRM

export AWS_PROFILE=NDR-Pre-Prod-Backup-RW
terraform init -backend-config=pre-prod.s3.tfbackend -upgrade -reconfigure
terraform workspace list
terraform workspace select pre-prod
terraform plan
terraform apply

export AWS_PROFILE=NDR-Prod-Backup-RW
terraform init -backend-config=prod.s3.tfbackend -upgrade -reconfigure
terraform workspace list
terraform workspace select prod-backup
terraform plan
terraform apply
```
