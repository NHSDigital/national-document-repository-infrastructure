# Document Store Bucket
module "ndr-document-store" {
  source                    = "./modules/s3/"
  bucket_name               = var.docstore_bucket_name
  enable_cors_configuration = true
  environment               = var.environment
  owner                     = var.owner
  force_destroy             = contains(["ndra", "ndrb", "ndrc", "ndrd", "ndr-test"], terraform.workspace)
  cors_rules = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["POST", "DELETE"]
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
  force_destroy             = contains(["ndra", "ndrb", "ndrc", "ndrd", "ndr-test"], terraform.workspace)
  cors_rules = [
    {
      allowed_methods = ["GET"]
      allowed_origins = ["https://${terraform.workspace}.${var.domain}"]
    }
  ]
}

# Lloyd George Store Bucket
module "ndr-lloyd-george-store" {
  source                    = "./modules/s3/"
  bucket_name               = var.lloyd_george_bucket_name
  enable_cors_configuration = true
  environment               = var.environment
  owner                     = var.owner
  force_destroy             = contains(["ndra", "ndrb", "ndrc", "ndrd", "ndr-test"], terraform.workspace)
  cors_rules = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["POST", "DELETE"]
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
    id     = "Delete LG records after soft delete"
    status = "Enabled"

    expiration {
      days = 56
    }

    filter {
      tag {
        key   = "soft-delete"
        value = "true"
      }
    }
  }
  rule {
    id     = "Delete LG records after death"
    status = "Enabled"

    expiration {
      days = 3650
    }

    filter {
      tag {
        key   = "patient-death"
        value = "true"
      }
    }
  }
  rule {
    id     = "default-to-intelligent-tiering"
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "doc-store-lifecycle-rules" {
  bucket = module.ndr-document-store.bucket_id
  rule {
    id     = "Delete DS records after soft delete"
    status = "Enabled"

    expiration {
      days = 56
    }

    filter {
      tag {
        key   = "soft-delete"
        value = "true"
      }
    }
  }
  rule {
    id     = "Delete DS records after death"
    status = "Enabled"

    expiration {
      days = 3650
    }

    filter {
      tag {
        key   = "patient-death"
        value = "true"
      }
    }
  }
  rule {
    id     = "default-to-intelligent-tiering"
    status = "Enabled"
  }
}

# Staging Bucket for bulk uploads
module "ndr-bulk-staging-store" {
  source                    = "./modules/s3/"
  bucket_name               = var.staging_store_bucket_name
  environment               = var.environment
  owner                     = var.owner
  force_destroy             = contains(["ndra", "ndrb", "ndrc", "ndrd", "ndr-test"], terraform.workspace)
  enable_cors_configuration = false
}
