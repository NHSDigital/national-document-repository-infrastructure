
resource "aws_sqs_queue" "sqs_queue" {
  name                       = var.name
  delay_seconds              = var.delay
  visibility_timeout_seconds = var.max_visibility
  max_message_size           = var.max_message
  message_retention_seconds  = var.message_retention
  receive_wait_time_seconds  = var.receive_wait
  sqs_managed_sse_enabled    = var.enable_sse
}