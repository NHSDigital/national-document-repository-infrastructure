module "ndr-document-store" {
  source      = "./modules/s3/"
  bucket_name = "ndr-document-store"
}