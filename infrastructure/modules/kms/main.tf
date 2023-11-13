resource "aws_kms_key" "encryption_key" {
  description         = var.kms_key_description
  policy              = data.aws_iam_policy_document.kms_key_policy_doc.json
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

output "id" {
  value = aws_kms_key.encryption_key.id
}

data "aws_iam_policy_document" "kms_key_policy_doc" {
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