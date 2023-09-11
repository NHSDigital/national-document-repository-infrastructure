resource "aws_sns_topic" "sns_topic" {
  name                        = var.topic_name
  delivery_policy             = var.delivery_policy
  fifo_topic                  = var.fifo
  content_based_deduplication = var.content_based_deduplication
}

resource "aws_sns_topic_subscription" "sns_invocation" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = var.protocol
  endpoint  = module.sns_topic.function_arn
}