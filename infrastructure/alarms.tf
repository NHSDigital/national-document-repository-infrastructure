resource "aws_cloudwatch_metric_alarm" "repo_alarm" {
  alarm_name        = "${terraform.workspace}_repo_5xx_alert"
  alarm_description = "Triggers when a 5xx error is detected on the Api Gateway"
  namespace         = "AWS/ApiGateway"
  dimensions = {
    ApiName = aws_api_gateway_rest_api.ndr_doc_store_api.name
  }
  metric_name         = "5XXError"
  treat_missing_data  = "notBreaching"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 0.05
  period              = 60
  evaluation_periods  = 2
  statistic           = "Sum"
  unit                = "Count"
}

resource "aws_cloudwatch_metric_alarm" "api_gateway_alarm_4XX" {
  alarm_name          = "4XX-status-${aws_api_gateway_rest_api.ndr_doc_store_api.name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  namespace           = "AWS/ApiGateway"
  metric_name         = "4XXError"
  period              = "60"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    ApiName = aws_api_gateway_rest_api.ndr_doc_store_api.name
    #    stage   = "prod"
  }

  alarm_description = "This alarm indicates that at least 20 4XX statuses have occured on ${aws_api_gateway_rest_api.ndr_doc_store_api.name} in a minute."
  actions_enabled   = "true"
  alarm_actions     = [aws_sns_topic.alarm_notifications_topic.arn]
}

resource "aws_cloudwatch_metric_alarm" "api_gateway_alarm_5XX" {
  alarm_name          = "5XX-status-${aws_api_gateway_rest_api.ndr_doc_store_api.name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  namespace           = "AWS/APIGateway"
  metric_name         = "5XXError"
  period              = "300"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    ApiName = aws_api_gateway_rest_api.ndr_doc_store_api.name
    #    stage   = "prod"
  }

  alarm_description = "This alarm indicates that at least 5 5XX statuses have occured on ${aws_api_gateway_rest_api.ndr_doc_store_api.name} within 5 minutes."
  actions_enabled   = "true"
  alarm_actions     = [aws_sns_topic.alarm_notifications_topic.arn]
}
/**

Module required to create gateway alarm subscription below. 
As there is no notification provider such as email, 
phone number or sqs queue planned yet the code is commented

**/

#module "alarm_notifications_topic" {
#  source         = "./modules/sns"
#  topic_name     = "alarm_notifications-topic"
#  topic_protocol = "email"
#  topic_endpoint = toset(nonsensitive(split(",", data.aws_ssm_parameter.cloud_security_notification_email_list.value)))
#  depends_on     = [aws_api_gateway_rest_api.ndr_doc_store_api]
#  delivery_policy = jsonencode({
#    "Version" : "2012-10-17",
#    "Statement" : [
#      {
#        "Effect" : "Allow",
#        "Principal" : {
#          "Service" : "cloudwatch.amazonaws.com"
#        },
#        "Action" : [
#          "SNS:Publish",
#        ],
#        "Condition" : {
#          "ArnLike" : {
#            "aws:SourceArn" : "arn:aws:cloudwatch:eu-west-2:${data.aws_caller_identity.current.account_id}:alarm:*"
#          }
#        }
#        "Resource" : "*"
#      }
#    ]
#  })
#}

resource "aws_sns_topic" "alarm_notifications_topic" {
  name              = "alarms-notifications-topic-${terraform.workspace}"
  kms_master_key_id = aws_kms_key.alarm_notification_encryption_key.id
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
            "aws:SourceArn" : "arn:aws:cloudwatch:eu-west-2:${data.aws_caller_identity.current.account_id}:alarm:*"
          }
        }
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_sns_topic_subscription" "alarm_notifications_sns_topic_subscription" {
  for_each  = toset(nonsensitive(split(",", data.aws_ssm_parameter.cloud_security_notification_email_list.value)))
  endpoint  = each.value
  protocol  = "email"
  topic_arn = aws_sns_topic.alarm_notifications_topic.arn
}


data "aws_ssm_parameter" "cloud_security_notification_email_list" {
  name = "/prs/${var.environment}/user-input/cloud-security-notification-email-list"
}

/**

Resources required to create alarm notification encryption below,
as there is no kms key per ndr environment currently added.

**/

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
