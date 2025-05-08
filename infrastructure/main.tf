# Terraform Config

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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

data "aws_ssm_parameter" "apim_url" {
  name = "/repo/${var.environment}/user-input/apim-api-url"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # This is an example Amazon Linux 2 AMI ID (may need updating)
  instance_type = "t2.micro"

  # This will cause a validation error because 'nonexistent_parameter' 
  # is not a valid argument for aws_instance
  nonexistent_parameter = "this_will_fail"
}

