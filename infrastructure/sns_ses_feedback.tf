data "aws_iam_policy_document" "ses_feedback_topic_policy" {
  statement {
    sid    = "DefaultOwnerTopicPermissions"
    effect = "Allow"

    actions = [
      "sns:GetTopicAttributes",
      "sns:SetTopicAttributes",
      "sns:AddPermission",
      "sns:RemovePermission",
      "sns:DeleteTopic",
      "sns:Subscribe",
      "sns:ListSubscriptionsByTopic",
      "sns:Publish",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    resources = ["*"]
  }

  statement {
    sid     = "AllowSESPublish"
    effect  = "Allow"
    actions = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

module "ses_feedback_topic" {
  source                = "./modules/sns"
  topic_name            = "ses-feedback-events"
  topic_protocol        = "lambda"
  topic_endpoint        = module.ses-feedback-monitor-lambda.lambda_arn
  sns_encryption_key_id = module.sns_encryption_key.kms_arn
  raw_message_delivery  = false
  topic_policy_json     = data.aws_iam_policy_document.ses_feedback_topic_policy.json
  delivery_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = []
  })
}

resource "aws_lambda_permission" "allow_sns_invoke_ses_feedback_monitor" {
  statement_id  = "AllowSNSInvokeSesFeedbackMonitor"
  action        = "lambda:InvokeFunction"
  function_name = module.ses-feedback-monitor-lambda.lambda_arn
  principal     = "sns.amazonaws.com"
  source_arn    = module.ses_feedback_topic.arn
}
