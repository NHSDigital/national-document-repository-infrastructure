module "sqs-nrl-queue" {
  source            = "./modules/sqs"
  name              = "nrl-queue.fifo"
  environment       = var.environment
  owner             = var.owner
  message_retention = 1800
  enable_sse        = true
  enable_fifo       = true
  max_visibility    = 601
}
