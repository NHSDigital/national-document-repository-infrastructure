data "aws_iam_policy_document" "ses_feedback_topic_policy" {
  statement {
    sid     = "DefaultOwnerPermissions"
    effect  = "Allow"
    actions = ["SNS:*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    resources = ["*"]
  }

  statement {
    sid     = "AllowSESPublish"
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }
    resources = ["*"]
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
