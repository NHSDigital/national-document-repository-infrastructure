locals {
  monitored_queues = {
    # main queues
    "nrl_main"       = "nrl-queue-name"
    "splunk_main"    = "splunk-queue-name"
    "stitching_main" = "stitching-queue-name"
    "lg_bulk_main"   = "lg-bulk-upload-metadata-queue-name"
    "lg_inv_main"    = "lg-bulk-upload-invalid-queue-name"

    # dead-letter queues
    "nrl_dlq"    = "nrl-dlq-name"
    "splunk_dlq" = "splunk-dlq-name"
  }
}
locals {
  is_test_sandbox = contains([], terraform.workspace) # empty list disables sandbox detection, for testing only
}

module "global_sqs_age_alarm_topic" {
  count                  = local.is_test_sandbox ? 0 : 1
  source                 = "./modules/sns"
  sns_encryption_key_id  = module.sns_encryption_key.id
  current_account_id     = data.aws_caller_identity.current.account_id
  topic_name             = "global-sqs-age-alarm-topic"
  topic_protocol         = "email"
  is_topic_endpoint_list = true
  topic_endpoint_list    = nonsensitive(split(",", data.aws_ssm_parameter.cloud_security_notification_email_list.value))

  delivery_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudwatch.amazonaws.com"
        },
        "Action" : "SNS:Publish",
        "Condition" : {
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:cloudwatch:eu-west-2:${data.aws_caller_identity.current.account_id}:alarm:*"
          }
        },
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "sqs_oldest_message_alarm" {
  for_each = local.is_test_sandbox ? {} : local.monitored_queues

  alarm_name          = "${terraform.workspace}_${each.key}_oldest_message_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60 # test (prod: 10800)
  statistic           = "Maximum"
  threshold           = 60 # test (prod: 864000)
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = each.value
  }

  alarm_description = "Alarm when a message in queue '${each.value}' is older than 10 days."
  alarm_actions     = [module.global_sqs_age_alarm_topic[0].arn]

  tags = {
    Name        = "${terraform.workspace}_${each.key}_oldest_message_alarm"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}
resource "aws_sns_topic_subscription" "global_sqs_alarm_subscriptions" {
  for_each  = local.is_test_sandbox ? {} : toset(nonsensitive(split(",", data.aws_ssm_parameter.cloud_security_notification_email_list.value)))
  endpoint  = each.value
  protocol  = "email"
  topic_arn = module.global_sqs_age_alarm_topic[0].arn
}


