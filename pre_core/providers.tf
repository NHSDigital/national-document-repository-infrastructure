provider "aws" {
  region = var.region
  allowed_account_ids = [
    data.aws_caller_identity.current.account_id,
  ]
  default_tags {
    tags = {
      Owner       = var.owner
      Environment = var.environment
      Workspace   = terraform.workspace
    }
  }
}