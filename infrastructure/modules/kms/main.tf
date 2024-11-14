resource "aws_kms_key" "encryption_key" {
  description         = var.kms_key_description
  policy              = data.aws_iam_policy_document.combined_policy_documents.json
  enable_key_rotation = var.kms_key_rotation_enabled

  tags = {
    Name        = var.kms_key_name
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

resource "aws_kms_alias" "encryption_key_alias" {
  name          = var.kms_key_name
  target_key_id = aws_kms_key.encryption_key.id
}


data "aws_iam_policy_document" "kmn_key_base" {
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
      identifiers = var.service_identifiers
      type        = "Service"
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]
    dynamic "condition" {
      for_each = var.allow_decrypt_for_arn ? [1] : []
      content {
        key   = "ArnEquals"
        value = var.allowed_arn
      }
    }
  }
}

data "aws_iam_policy_document" "kms_key_generate" {
  statment {
    effect = "Allow"
    principals {
      identifiers = var.aws_identifiers
      type        = "AWS"
    }
    action    = ["kms:GenerateDataKey"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "combined_policy_documents" {
  source_policy_documents = [
    data.aws_iam_policy_document.kmn_key_base.json,
    data.aws_iam_policy_document.kms_key_generate.json
  ]
}

