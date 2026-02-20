locals {
  base_topic_policy_json = var.topic_policy_json != null ? var.topic_policy_json : var.delivery_policy
  base_topic_policy_obj  = jsondecode(local.base_topic_policy_json)
  normalized_statements = [
    for s in try(local.base_topic_policy_obj["Statement"], []) : merge(
      s,
      {
        Resource = (
          try(s["Resource"], null) == "*" || try(s["Resource"], null) == null
          ? aws_sns_topic.sns_topic.arn
          : s["Resource"]
        )
      }
    )
  ]

  ses_publish_statement = var.enable_ses_publish ? {
    Sid    = "AllowSESPublish"
    Effect = "Allow"
    Principal = {
      Service = "ses.amazonaws.com"
    }
    Action   = "SNS:Publish"
    Resource = aws_sns_topic.sns_topic.arn
    Condition = {
      StringEquals = {
        "AWS:SourceAccount" = var.ses_source_account_id
      }
    }
  } : null

  effective_topic_policy_obj = merge(
    local.base_topic_policy_obj,
    {
      Statement = concat(
        local.normalized_statements,
        var.enable_ses_publish ? [local.ses_publish_statement] : []
      )
    }
  )
  effective_topic_policy_json = jsonencode(local.effective_topic_policy_obj)
}

resource "aws_sns_topic" "sns_topic" {
  name_prefix                 = "${terraform.workspace}-sns-${var.topic_name}"
  fifo_topic                  = var.enable_fifo
  content_based_deduplication = var.enable_deduplication
  kms_master_key_id           = var.sns_encryption_key_id

  sqs_failure_feedback_role_arn    = try(var.sqs_feedback.failure_role_arn, null)
  sqs_success_feedback_role_arn    = try(var.sqs_feedback.success_role_arn, null)
  sqs_success_feedback_sample_rate = try(var.sqs_feedback.success_sample_rate, null)
}

resource "aws_sns_topic_policy" "this" {
  arn    = aws_sns_topic.sns_topic.arn
  policy = local.effective_topic_policy_json
}

resource "aws_sns_topic_subscription" "sns_subscription_single" {
  count                = var.is_topic_endpoint_list ? 0 : 1
  topic_arn            = aws_sns_topic.sns_topic.arn
  protocol             = var.topic_protocol
  endpoint             = var.topic_endpoint
  raw_message_delivery = var.raw_message_delivery

  depends_on = [aws_sns_topic_policy.this]
}

resource "aws_sns_topic_subscription" "sns_subscription_list" {
  for_each             = toset(var.topic_endpoint_list)
  topic_arn            = aws_sns_topic.sns_topic.arn
  protocol             = var.topic_protocol
  endpoint             = each.value
  raw_message_delivery = var.raw_message_delivery

  depends_on = [aws_sns_topic_policy.this]
}

output "arn" {
  value = aws_sns_topic.sns_topic.arn
}
