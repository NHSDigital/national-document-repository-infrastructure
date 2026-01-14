module "ses_feedback_topic" {
  source                = "./modules/sns"
  topic_name            = "ses-feedback-events"
  topic_protocol        = "lambda"
  topic_endpoint        = module.ses-feedback-monitor-lambda.lambda_arn
  sns_encryption_key_id = module.sns_encryption_key.kms_arn
  raw_message_delivery  = false

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
          "SNS:Publish"
        ]
        Resource = "*"
      }
    ]
  })

  enable_ses_publish    = true
  ses_source_account_id = data.aws_caller_identity.current.account_id
}
