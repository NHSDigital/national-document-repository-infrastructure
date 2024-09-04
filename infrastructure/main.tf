# Terraform Config

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.11.0"
    }
  }
  backend "s3" {
    dynamodb_table = "ndr-terraform-locks"
    region         = "eu-west-2"
    key            = "ndr/terraform.tfstate"
    encrypt        = true
  }
}
provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
data "aws_caller_identity" "current" {
}

data "aws_region" "current" {}

data "aws_elb_service_account" "main" {}
