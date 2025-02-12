# Document Store Bucket
module "ndr-document-store" {
  source                    = "./modules/s3/"
  bucket_name               = var.docstore_bucket_name
  enable_cors_configuration = true
  enable_bucket_versioning  = true
  environment               = var.environment
  owner                     = var.owner
  force_destroy             = local.is_force_destroy
  cors_rules = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["POST", "PUT", "DELETE"]
      allowed_origins = ["https://${terraform.workspace}.${var.domain}"]
      expose_headers  = ["ETag"]
      max_age_seconds = 3000
    },
    {
      allowed_methods = ["GET"]
      allowed_origins = ["https://${terraform.workspace}.${var.domain}"]
    }
  ]
}

# Zip Request Store Bucket
module "ndr-zip-request-store" {
  source                    = "./modules/s3/"
  bucket_name               = var.zip_store_bucket_name
  enable_cors_configuration = true
  environment               = var.environment
  owner                     = var.owner
  force_destroy             = local.is_force_destroy
  cors_rules = [
    {
      allowed_methods = ["GET"]
      allowed_origins = [contains(["prod"], terraform.workspace) ? "https://${var.domain}" : "https://${terraform.workspace}.${var.domain}"]
    }
  ]
}
# Lloyd George Store Bucket
module "ndr-lloyd-george-store" {
  source                    = "./modules/s3/"
  cloudfront_enabled        = true
  cloudfront_arn            = module.cloudfront-distribution-lg.cloudfront_arn
  bucket_name               = var.lloyd_george_bucket_name
  enable_cors_configuration = contains(["prod"], terraform.workspace) ? false : true
  enable_bucket_versioning  = true
  environment               = var.environment
  owner                     = var.owner
  force_destroy             = local.is_force_destroy
  cors_rules = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["POST", "PUT", "DELETE"]
      allowed_origins = ["https://${terraform.workspace}.${var.domain}"]
      expose_headers  = ["ETag"]
      max_age_seconds = 3000
    },
    {
      allowed_methods = ["GET"]
      allowed_origins = ["https://${terraform.workspace}.${var.domain}"]
    }
  ]
}


module "statistical-reports-store" {
  source                    = "./modules/s3/"
  bucket_name               = var.statistical_reports_bucket_name
  enable_cors_configuration = true
  enable_bucket_versioning  = true
  environment               = var.environment
  owner                     = var.owner
  force_destroy             = local.is_force_destroy
  cors_rules = [
    {
      allowed_methods = ["GET"]
      allowed_origins = [contains(["prod"], terraform.workspace) ? "https://${var.domain}" : "https://${terraform.workspace}.${var.domain}"]
    }
  ]
}


# Lifecycle Rules
resource "aws_s3_bucket_lifecycle_configuration" "lg-lifecycle-rules" {
  bucket = module.ndr-lloyd-george-store.bucket_id
  rule {
    id     = "Delete stitched LG records"
    status = "Enabled"

    expiration {
      days = 1
    }

    filter {
      tag {
        key   = "autodelete"
        value = "true"
      }
    }
  }
  rule {
    id     = "default-to-intelligent-tiering"
    status = "Enabled"
    transition {
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "doc-store-lifecycle-rules" {
  bucket = module.ndr-document-store.bucket_id
  rule {
    id     = "default-to-intelligent-tiering"
    status = "Enabled"
    transition {
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "staging-store-lifecycle-rules" {
  bucket = module.ndr-bulk-staging-store.bucket_id
  rule {
    id     = "Delete objects in user_upload folder that have existed for 24 hours"
    status = "Enabled"

    expiration {
      days = 1
    }

    filter {
      prefix = "user_upload/"
    }
  }
}

# Staging Bucket for bulk uploads
module "ndr-bulk-staging-store" {
  source                    = "./modules/s3/"
  bucket_name               = var.staging_store_bucket_name
  enable_cors_configuration = true
  enable_bucket_versioning  = true
  environment               = var.environment
  owner                     = var.owner
  force_destroy             = local.is_force_destroy
  cors_rules = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["POST", "PUT", "DELETE"]
      allowed_origins = ["https://${terraform.workspace}.${var.domain}"]
      expose_headers  = ["ETag"]
      max_age_seconds = 3000
    },
    {
      allowed_methods = ["GET"]
      allowed_origins = ["https://${terraform.workspace}.${var.domain}"]
    }
  ]
}

resource "aws_s3_bucket" "logs_bucket" {
  bucket        = "${terraform.workspace}-load-balancer-logs-${data.aws_caller_identity.current.account_id}"
  force_destroy = local.is_force_destroy

  tags = {
    Name        = "${terraform.workspace}-load-balancer-logs-${data.aws_caller_identity.current.account_id}"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

resource "aws_s3_bucket_versioning" "logs_bucket" {
  bucket = aws_s3_bucket.logs_bucket.id

  versioning_configuration {
    status = contains(["pre-prod", "prod"], terraform.workspace) ? "Enabled" : "Disabled"
  }

  depends_on = [aws_s3_bucket.logs_bucket]
}

resource "aws_s3_bucket_public_access_block" "logs_bucket" {
  bucket = aws_s3_bucket.logs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "logs_bucket_policy" {
  statement {
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.logs_bucket.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.logs_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "logs_bucket_policy" {
  bucket = aws_s3_bucket.logs_bucket.id
  policy = data.aws_iam_policy_document.logs_bucket_policy.json
}


