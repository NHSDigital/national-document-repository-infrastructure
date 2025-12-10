variable "environment" {
  description = "Environment to bootstrap (dev, pre-prod, prod, etc)"
  type        = string
}

variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "The region to be used for bootstrapping"
}

variable "aws_account_id" {
  type        = string
  description = "The AWS Account ID (numeric)"
}
