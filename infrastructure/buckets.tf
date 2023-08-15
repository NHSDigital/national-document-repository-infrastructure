# Document Store Bucket
module "ndr-document-store" {
  source                    = "./modules/s3/"
  bucket_name               = var.docstore_bucket_name
  origin                    = "'https://${terraform.workspace}.${var.domain}'"
  enable_cors_configuration = true
  environment               = var.environment
  owner                     = var.owner
}