
module "5xx-alarm" {
  source        = "./modules/alarm"
  alarm_name    = "5xx_error"
  alarm_description = "Triggers when a 5xx status code has been returned by the DocStoreAPI." 
  namespace = "AWS/ApiGateway"
  api_name = module.aws_api_gateway_rest_api.lambda_api.name
  metric_name = "5XXError"
  alarm_actions = [aws_sns_topic.repo_alarm_notifications.arn] 
  ok_actions = [aws_sns_topic.repo_alarm_notifications.arn] 
}


resource "aws_sns_topic" "repo_alarm_notifications" {
  name = "alarms-notifications-topic"
  policy = jsonencode({
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
            "aws:SourceArn" : "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:*"
          }
        }
        "Resource" : "*"
      }
    ]
  })
}


resource "aws_kms_key" "alarm_notification_encryption_key" {
  description         = "Custom KMS Key to enable server side encryption for alarm notifications"
  policy              = data.aws_iam_policy_document.alarm_notification_kms_key_policy_doc.json
  enable_key_rotation = true
}

resource "aws_kms_alias" "alarm_notification_encryption_key_alias" {
  name          = "alias/alarm-notification-encryption-key-kms-${terraform.workspace}"
  target_key_id = aws_kms_key.alarm_notification_encryption_key.id
}


data "aws_iam_policy_document" "alarm_notification_kms_key_policy_doc" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
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
