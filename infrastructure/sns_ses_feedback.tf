module "ses_feedback_topic" {
  source                = "./modules/sns"
  topic_name            = "ses-feedback-events"
  topic_protocol        = "lambda"
  topic_endpoint        = module.ses-feedback-monitor-lambda.lambda_arn
  sns_encryption_key_id = module.sns_encryption_key.kms_arn

  delivery_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DefaultOwnerPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "SNS:GetTopicAttributes",
          "SNS:SetTopicAttributes",
          "SNS:AddPermission",
          "SNS:RemovePermission",
          "SNS:DeleteTopic",
          "SNS:Subscribe",
          "SNS:ListSubscriptionsByTopic",
          "SNS:Publish",
          "SNS:Receive"
        ]
        Resource = "*"
      }
    ]
  })
}

data "aws_iam_policy_document" "ses_feedback_topic_policy" {
  statement {
    sid    = "DefaultOwnerPermissions"
    effect = "Allow"
    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    resources = [module.ses_feedback_topic.arn]
  }

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

resource "aws_sns_topic_policy" "ses_feedback_topic_policy" {
  arn    = module.ses_feedback_topic.arn
  policy = data.aws_iam_policy_document.ses_feedback_topic_policy.json
}

resource "aws_lambda_permission" "allow_sns_invoke_ses_feedback_monitor" {
  statement_id  = "AllowSNSInvokeSesFeedbackMonitor"
  action        = "lambda:InvokeFunction"
  function_name = module.ses-feedback-monitor-lambda.lambda_arn
  principal     = "sns.amazonaws.com"
  source_arn    = module.ses_feedback_topic.arn
}
