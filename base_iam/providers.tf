provider "aws" {
  region = var.region
  allowed_account_ids = [
    var.aws_account_id
  ]
  default_tags {
    tags = {
      Owner       = var.owner
      Environment = var.environment
      Workspace   = terraform.workspace
    }
  }
}