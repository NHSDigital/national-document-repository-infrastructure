module "ndr-document-store" {
  source      = "./modules/s3/"
  bucket_name = var.docstore_bucket_name

  environment = var.environment
  owner       = var.owner
}