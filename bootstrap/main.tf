terraform {
  required_version = "> 1.5.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.52.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_kms_key" "state_key" {
  description = "ndr-dev-terraform-state-key"
  deletion_window_in_days = 10
  enable_key_rotation = true
}

resource "aws_s3_bucket" "s3_state" {
  bucket = "ndr-dev-terraform-state-${data.aws_caller_identity.current.account_id}"
  acl = "private"
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.state_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

    lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.s3_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name = "ndr-terraform-locks"
  hash_key = "LockId"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
    lifecycle {
    prevent_destroy = true
  }
}

data "aws_caller_identity" "current" {}

variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "The region to be used for bootstrapping"
}