resource "aws_sns_topic" "sns_topic" {
  name                        = "${terraform.workspace}-sns-${var.topic_name}"
  policy                      = var.delivery_policy
  fifo_topic                  = var.enable_fifo
  content_based_deduplication = var.enable_deduplication
}

output "arn" {
  value = aws_sns_topic.sns_topic.arn
}