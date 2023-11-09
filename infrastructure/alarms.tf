resource "aws_cloudwatch_metric_alarm" "api_gateway_alarm_4XX" {
  alarm_name          = "4XX-status-${aws_api_gateway_rest_api.ndr_doc_store_api.name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  namespace           = "AWS/ApiGateway"
  metric_name         = "4XXError"
  period              = 60
  statistic           = "Sum"
  threshold           = 20
  treat_missing_data  = "notBreaching"

  dimensions = {
    ApiName = aws_api_gateway_rest_api.ndr_doc_store_api.name
    #    stage   = "prod"
  }

  alarm_description = "This alarm indicates that at least 20 4XX statuses have occured on ${aws_api_gateway_rest_api.ndr_doc_store_api.name} in a minute."
  actions_enabled   = "true"
  alarm_actions     = [module.alarm_notifications_topic.arn]
}

resource "aws_cloudwatch_metric_alarm" "api_gateway_alarm_5XX" {
  alarm_name          = "5XX-status-${aws_api_gateway_rest_api.ndr_doc_store_api.name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  namespace           = "AWS/ApiGateway"
  metric_name         = "5XXError"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  treat_missing_data  = "notBreaching"

  dimensions = {
    ApiName = aws_api_gateway_rest_api.ndr_doc_store_api.name
    #    stage   = "prod"
  }

  alarm_description = "This alarm indicates that at least 5 5XX statuses have occured on ${aws_api_gateway_rest_api.ndr_doc_store_api.name} within 5 minutes."
  actions_enabled   = "true"
  alarm_actions     = [module.alarm_notifications_topic.arn]
}
/**

Module required to create gateway alarm subscription below. 
As there is no notification provider such as email, 
phone number or sqs queue planned yet the code is commented

**/

module "alarm_notifications_topic" {
  source             = "./modules/sns"
  current_account_id = data.aws_caller_identity.current.account_id
  topic_name         = "alarm_notifications-topic"
  topic_protocol     = "email"
  topic_endpoint     = toset(nonsensitive(split(",", data.aws_ssm_parameter.cloud_security_notification_email_list.value)))
  depends_on         = [aws_api_gateway_rest_api.ndr_doc_store_api]
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
#
#resource "aws_sns_topic" "alarm_notifications_topic" {
#  name_prefix       = "${terraform.workspace}-alarms-notification-topic-"
#  kms_master_key_id = aws_kms_key.sns_encryption_key.id
#  policy = jsonencode({
#    "Version" : "2012-10-17",
#    "Statement" : [
#      {
#        "Effect" : "Allow",
#        "Principal" : {
#          "Service" : "cloudwatch.amazonaws.com"
#        },
#        "Action" : "SNS:Publish",
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

resource "aws_sns_topic_subscription" "alarm_notifications_sns_topic_subscription" {
  # for_each = toset(nonsensitive(split(",", data.aws_ssm_parameter.cloud_security_notification_email_list.value)))
  # for_each  = toset(["abbas.khan10@nhs.net", "rachel.howell6@nhs.net"])
  endpoint  = "abbas.khan10@nhs.net"
  protocol  = "email"
  topic_arn = module.alarm_notifications_topic.arn
}


data "aws_ssm_parameter" "cloud_security_notification_email_list" {
  name = "/prs/${var.environment}/user-input/cloud-security-notification-email-list"
}

/**

Resources required to create alarm notification encryption below,
as there is no kms key per ndr environment currently added.

**/





