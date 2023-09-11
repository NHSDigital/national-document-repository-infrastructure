resource "aws_sns_topic" "sns_topic" {
  name                        = "${terraform.workspace}-sns-${var.topic_name}"
  delivery_policy             = var.delivery_policy
  fifo_topic                  = var.enable_fifo
  content_based_deduplication = var.enable_deduplication
}

resource "aws_sns_topic_subscription" "sns_invocation" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = var.protocol
  endpoint  = var.sns_function_arn
}