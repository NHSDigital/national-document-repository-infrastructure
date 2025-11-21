module "lg-bulk-upload-expedite-metadata-queue" {
  source                = "./modules/sqs"
  name                  = "lg-bulk-upload-expedite-metadata-queue.fifo"
  max_size_message      = 256 * 1024        # allow message size up to 256 KB
  message_retention     = 60 * 60 * 24 * 14 # 14 days
  environment           = var.environment
  owner                 = var.owner
  max_visibility        = 1020
  enable_fifo           = true
  enable_deduplication  = true
  delay                 = 60
  enable_dlq            = true
  dlq_message_retention = 1209600 # 14 days
}
