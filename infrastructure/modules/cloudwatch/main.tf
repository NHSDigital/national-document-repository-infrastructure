resource "aws_cloudwatch_log_group" "ndr" {
  name              = var.log_group_name
  kms_key_id        = var.log_group_encryption_key
  retention_in_days = var.retention_in_days
  skip_destroy      = true
  log_group_class   = "STANDARD"


  tags = {
    Name        = "${var.log_group_name}_log_group"
    Owner       = var.owner
    Environment = var.environment
  }
}