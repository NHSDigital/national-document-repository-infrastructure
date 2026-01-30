# Based on settings in infrastructure/main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }


  backend "s3" {
    use_lockfile = true
    region       = "eu-west-2"
    key          = "ndr_base_iam/terraform.tfstate"
    encrypt      = true
  }
}
