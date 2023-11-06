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
  metric_name         = "HTTPCode_Target_4XX_Count"
  period              = "60"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    ApiName = aws_api_gateway_rest_api.ndr_doc_store_api.name
    stage   = "prod"
  }

  alarm_description = "This alarm indicates that at least 20 4XX statuses have occured on ${aws_api_gateway_rest_api.ndr_doc_store_api.name} in a minute."
  alarm_actions     = var.alarm_actions_arn_list
}

resource "aws_cloudwatch_metric_alarm" "gateway_alarm_5XX" {
  alarm_name          = "5XX-status-${aws_api_gateway_rest_api.ndr_doc_store_api.name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  namespace           = "AWS/APIGateway"
  metric_name         = "API_Gateway_5xx_Error"
  period              = "300"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    ApiName = aws_api_gateway_rest_api.ndr_doc_store_api.name
    stage   = "prod"
  }

  alarm_description = "This alarm indicates that at least 5 5XX statuses have occured on ${aws_api_gateway_rest_api.ndr_doc_store_api.name} within 5 minutes."
  alarm_actions     = var.alarm_actions_arn_list
}
/**

Module required to create gateway alarm subscription below. 
As there is no notification provider such as email, 
phone number or sqs queue planned yet the code is commented

**/

# module "sns_gateway_alarms_topic" {
#   source         = "./modules/sns"
#   topic_name     = "gateway-alarms-topic"
#   topic_protocol = "application"
#   topic_endpoint = "arn:aws:apigateway:eu-west-2:${data.aws_caller_identity.current.account_id}:/apis/${aws_api_gateway_rest_api.ndr_doc_store_api.id}/routes/*"
#   depends_on     = [aws_api_gateway_rest_api.ndr_doc_store_api]
#   delivery_policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Effect" : "Allow",
#         "Principal" : {
#           "Service" : "cloudwatch.amazonaws.com"
#         },
#         "Action" : [
#           "SNS:Publish",
#         ],
#         "Condition" : {
#           "ArnLike" : {
#             "aws:SourceArn" : "arn:aws:cloudwatch:eu-west-2:${data.aws_caller_identity.current.account_id}:alarm:*"
#           }
#         }
#         "Resource" : "*"
#       }
#     ]
#   })
# }

/**

Resources required to create alarm notification encryption below,
as there is no kms key per ndr environment currently added.

**/

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
