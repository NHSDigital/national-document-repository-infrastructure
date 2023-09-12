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
