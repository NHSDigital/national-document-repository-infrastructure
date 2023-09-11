module "sqs-splunk-queue" {
  source = "./modules/sqs"
  name   = "${terraform.workspace}-sqs-splunk-queue"
}