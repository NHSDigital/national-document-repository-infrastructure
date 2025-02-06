module "sqs-stitching-queue-deadletter" {
  source               = "./modules/sqs"
  name                 = "stitching-queue"
  environment          = var.environment
  owner                = var.owner
  message_retention    = 1800
  enable_sse           = true
  max_visibility       = 601
  enable_deduplication = true
  enable_dlq           = true
}