resource "aws_cloudwatch_metric_alarm" "repo_alarm" {
  alarm_name        = "${terraform.workspace}_repo_5xx_alert"
  alarm_description = "Triggers when a 5xx error is detected on the Api Gateway"
  namespace         = "AWS/ApiGateway"
  dimensions = {
    ApiName = aws_api_gateway_rest_api.ndr_doc_store_api.name
  }
  metric_name         = "5XXError"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "0"
  period              = "300"
  evaluation_periods  = "1"
  statistic           = "Sum"
  actions_enabled     = "true"
  alarm_actions       = [module.sns_alarms_topic.arn]
  ok_actions          = [module.sns_alarms_topic.arn]
  depends_on          = [module.sns_alarms_topic, aws_api_gateway_rest_api.ndr_doc_store_api]
}

module "sns_alarms_topic" {
  source         = "./modules/sns"
  topic_name     = "alarms-notifications-topic"
  topic_protocol = "sqs"
  topic_endpoint = aws_api_gateway_rest_api.ndr_doc_store_api.arn
  depends_on     = [aws_api_gateway_rest_api.ndr_doc_store_api]
  delivery_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudwatch.amazonaws.com"
        },
        "Action" : [
          "SNS:Publish",
        ],
        "Condition" : {
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:cloudwatch:eu-west-2:${data.aws_caller_identity.current.account_id}:alarm:*"
          }
        }
        "Resource" : "*"
      }
    ]
  })
}



# resource "aws_kms_key" "alarm_notification_encryption_key" {
#   description         = "Custom KMS Key to enable server side encryption for alarm notifications"
#   policy              = data.aws_iam_policy_document.alarm_notification_kms_key_policy_doc.json
#   enable_key_rotation = true
# }

# resource "aws_kms_alias" "alarm_notification_encryption_key_alias" {
#   name          = "alias/alarm-notification-encryption-key-kms-${terraform.workspace}"
#   target_key_id = aws_kms_key.alarm_notification_encryption_key.id
# }


data "aws_iam_policy_document" "alarm_notification_kms_key_policy_doc" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    principals {
      identifiers = ["sns.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    principals {
      identifiers = ["cloudwatch.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]
  }
}
