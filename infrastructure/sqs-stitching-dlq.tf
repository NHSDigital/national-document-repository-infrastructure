module "sqs-stitching-queue-deadletter" {
  source               = "./modules/sqs"
  name                 = "stitching-queue-dlq"
  environment          = var.environment
  owner                = var.owner
  message_retention    = 1800
  enable_sse           = true
  max_visibility       = 601
  enable_dlq           = true
}