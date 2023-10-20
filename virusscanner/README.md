# Virus Scanner

This module is for the Virus Scanning subsystem only
More details can be found in Confluence [here](https://gpitbjss.atlassian.net/wiki/spaces/TW/pages/12406227067/Virus+Scanner+maintenance)

## Deployment

Navigate to the Terraform folder
`./virusscanner/terraform`

awsume into your role 
`awsume nhse-dev`

init your Terraform
`terraform init --var-file=dev.tfvars -backend-config=dev.s3.tfbackend`

Plan the Terraform
`terraform plan --var-file=dev.tfvars -out=virusscanner.tfplan`

Deploy the Terraform
`terraform apply "virusscanner.tfplan"`