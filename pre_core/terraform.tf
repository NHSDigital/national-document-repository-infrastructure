# Based on settings in infrastructure/main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # awscc = {
    #   source  = "hashicorp/awscc"
    #   version = "~> 1.0"
    # }
  }


  # backend "s3" {
  #   use_lockfile = true
  #   region       = "eu-west-2"
  #   # key          = "ndr/terraform.tfstate"
  #   key          = "ndr_pre_core/terraform.tfstate"
  #   encrypt      = true
  # }
}