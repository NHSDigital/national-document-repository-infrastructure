# Allow SES to publish to the SES feedback SNS topic (topic policy is attached after topic creation)
data "aws_iam_policy_document" "ses_publish_to_sns" {
  statement {
    sid     = "AllowSESPublish"
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }

    resources = [module.ses_feedback_topic.arn]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

module "ses_feedback_topic" {
  source                = "./modules/sns"
  topic_name            = "ses-feedback-events"

  delivery_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = []
  })

  enable_fifo           = false
  enable_deduplication  = false
  raw_message_delivery  = true
  sns_encryption_key_id = module.sns_encryption_key.kms_arn
  topic_protocol        = "lambda"
  topic_endpoint        = module.ses-feedback-monitor-lambda.lambda_arn
}

resource "aws_sns_topic_policy" "ses_feedback_allow_ses_publish" {
  arn    = module.ses_feedback_topic.arn
  policy = data.aws_iam_policy_document.ses_publish_to_sns.json
}

resource "aws_lambda_permission" "allow_sns_invoke_ses_feedback_monitor" {
  statement_id  = "AllowSNSInvokeSesFeedbackMonitor"
  action        = "lambda:InvokeFunction"
  function_name = module.ses-feedback-monitor-lambda.lambda_arn
  principal     = "sns.amazonaws.com"
  source_arn    = module.ses_feedback_topic.arn
}
