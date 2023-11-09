resource "aws_sns_topic" "sns_topic" {
  name_prefix                 = "${terraform.workspace}-sns-${var.topic_name}"
  policy                      = var.delivery_policy
  fifo_topic                  = var.enable_fifo
  content_based_deduplication = var.enable_deduplication
  kms_master_key_id           = aws_kms_key.sns_encryption_key.id
}

resource "aws_sns_topic_subscription" "sns_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = var.topic_protocol
  for_each  = var.topic_endpoint
  endpoint  = each.value
}

output "arn" {
  value = aws_sns_topic.sns_topic.arn
}

resource "aws_kms_key" "sns_encryption_key" {
  description         = "Custom KMS Key to enable server side encryption for sns subscriptions"
  policy              = data.aws_iam_policy_document.sns_kms_key_policy_doc.json
  enable_key_rotation = true
}

resource "aws_kms_alias" "sns_encryption_key_alias" {
  name          = "alias/alarm-notification-encryption-key-kms-${terraform.workspace}"
  target_key_id = aws_kms_key.sns_encryption_key.id

}

data "aws_iam_policy_document" "sns_kms_key_policy_doc" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${var.current_account_id}:root"]
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