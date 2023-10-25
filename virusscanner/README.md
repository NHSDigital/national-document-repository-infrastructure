# Virus Scanner

This module is for the Virus Scanning subsystem only
More details can be found in Confluence [here](https://gpitbjss.atlassian.net/wiki/spaces/TW/pages/12406227067/Virus+Scanner+maintenance)

## Initial set up

This needs to be done once per AWS environment. You need to create the S3 bucket that will store the current Terraform 
state and the DynamoDB table that will contain the Terraform Lock, which will prevent multiple users deploying or 
destroying the Virus Scanner simultaneously and causing problems.

First, create the following in your AWS environment:

S3 bucket:

`virus-scanner-terraform-state`

DynamoDB table:

`virus-scanner-terraform-lock`

## Configuration

The virus scanner will inhabit the same VPC and Internet Gateway as other resources for the project.
The Terraform should pick this up if you've configured your Terraform Workspace correctly:

`terraform workspace new ndr-dev`


## Deployment

Navigate to the Terraform folder

`./virusscanner/terraform`

awsume into your role 

`awsume {role name}`

init your Terraform

`terraform init --var-file=dev.tfvars -backend-config=dev.s3.tfbackend`

Plan the Terraform

`terraform plan --var-file=dev.tfvars -out=virusscanner.tfplan`

Deploy the Terraform

`terraform apply "virusscanner.tfplan"`

Tear it down if necessary

`terraform destroy --var-file=dev.tfvars`