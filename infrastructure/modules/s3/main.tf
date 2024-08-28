resource "aws_s3_bucket" "bucket" {
  bucket        = "${terraform.workspace}-${var.bucket_name}"
  force_destroy = var.force_destroy

  tags = {
    Name        = "${terraform.workspace}-${var.bucket_name}"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

data "aws_iam_policy_document" "s3_defaut_policy" {
  statement {
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
      "${aws_s3_bucket.bucket.arn}",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

data "aws_iam_policy_document" "s3_cloudfront_policy" {
  statement {
    effect = "Deny"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
      "${aws_s3_bucket.bucket.arn}",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [var.cloudfront_arn] # Use CloudFront Distribution ARN here
    }
  }

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:UserAgent"
      values   = ["AWS-SigV4-CloudFront"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [var.cloudfront_arn]
    }
  }
}

data "aws_iam_policy_document" "s3_cloudfront_debug_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]

    # Temporarily remove all conditions to allow more open access for debugging
    # condition {
    #   test     = "StringEquals"
    #   variable = "AWS:SourceArn"
    #   values   = [var.cloudfront_distribution_arn]
    # }

    # condition {
    #   test     = "StringEquals"
    #   variable = "aws:UserAgent"
    #   values   = ["AWS-SigV4-CloudFront"]
    # }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_cloudfront_debug_policy.json
}

# resource "aws_s3_bucket_policy" "bucket_policy" {
#   bucket     = aws_s3_bucket.bucket.id
#   policy     = var.cloudfront_enabled ? data.aws_iam_policy_document.s3_cloudfront_policy.json : data.aws_iam_policy_document.s3_defaut_policy.json
#   depends_on = [aws_s3_bucket.bucket]
# }

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket     = aws_s3_bucket.bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
  depends_on = [aws_s3_bucket.bucket, aws_s3_bucket_policy.bucket_policy]
}

resource "aws_s3_bucket_cors_configuration" "document_store_bucket_cors_config" {
  bucket = aws_s3_bucket.bucket.id
  count  = var.enable_cors_configuration ? 1 : 0
  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_headers = try(cors_rule.value.allowed_headers, null)
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = try(cors_rule.value.expose_headers, null)
      max_age_seconds = try(cors_rule.value.max_age_seconds, null)
    }
  }
  depends_on = [aws_s3_bucket.bucket, aws_s3_bucket_acl.bucket_acl]
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  count  = var.enable_bucket_versioning ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [aws_s3_bucket.bucket]
}