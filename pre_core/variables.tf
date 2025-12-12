variable "environment" {
  description = "Environment to bootstrap (dev, pre-prod, prod, etc)"
  type        = string
}

variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "The region to be used for bootstrapping"
}

# variable "aws_account_id" {
#   type        = string
#   description = "The AWS Account ID (numeric)"
# }

variable "owner" {
  description = "Identifies the team or person responsible for the resource (used for tagging)."
  type        = string
  default     = "nhse/ndr-team"
}

locals {
  is_sandbox    = !contains(["ndr-dev", "ndr-test", "pre-prod", "prod"], terraform.workspace)
  is_production = contains(["pre-prod", "prod"], terraform.workspace)

  is_sandbox_or_dev = !contains(["ndr-test", "pre-prod", "prod"], terraform.workspace)
  is_development    = terraform.workspace == "ndr-dev"
  is_testing        = terraform.workspace == "ndr-test"
  is_pre_production = terraform.workspace == "pre-prod"
  is_prod           = terraform.workspace == "prod"
}