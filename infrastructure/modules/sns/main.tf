resource "aws_sns_topic" "sns_topic" {
  name_prefix                      = "${terraform.workspace}-sns-${var.topic_name}"
  policy                           = var.delivery_policy
  fifo_topic                       = var.enable_fifo
  content_based_deduplication      = var.enable_deduplication
  kms_master_key_id                = var.sns_encryption_key_id
  sqs_failure_feedback_role_arn    = try(var.sqs_feedback.failure_role_arn, null)
  sqs_success_feedback_role_arn    = try(var.sqs_feedback.success_role_arn, null)
  sqs_success_feedback_sample_rate = try(var.sqs_feedback.success_sample_rate, null)
}

resource "aws_sns_topic_subscription" "sns_subscription_single" {
  count                = var.is_topic_endpoint_list ? 1 : 0
  topic_arn            = aws_sns_topic.sns_topic.arn
  protocol             = var.topic_protocol
  endpoint             = var.topic_endpoint
  raw_message_delivery = var.raw_message_delivery
}

resource "aws_sns_topic_subscription" "sns_subscription_list" {
  for_each             = toset(var.topic_endpoint_list)
  topic_arn            = aws_sns_topic.sns_topic.arn
  protocol             = var.topic_protocol
  endpoint             = each.value
  raw_message_delivery = var.raw_message_delivery
}

output "arn" {
  value = aws_sns_topic.sns_topic.arn
}
