module "sqs-nrl-queue" {
  source               = "./modules/sqs"
  name                 = "nrl-queue.fifo"
  environment          = var.environment
  owner                = var.owner
  message_retention    = 1800
  enable_sse           = true
  enable_fifo          = true
  max_visibility       = 601
  enable_deduplication = true
  enable_dlq           = true
}

resource "aws_cloudwatch_metric_alarm" "nrl_dlq_new_messages_alarm" {
  alarm_name          = "NRL_DLQ_MESSAGES"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "Alarm when there are new messages in the nrl dlq queue"

  dimensions = {
    QueueName = module.sqs-nrl-queue.dlq_name
  }
}