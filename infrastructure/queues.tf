module "sqs-splunk-queue" {
  source      = "./modules/sqs"
  name        = "splunk-queue"
  count       = local.is_sandbox ? 0 : 1
  environment = var.environment
  owner       = var.owner
}

module "sqs-nems-queue" {
  source      = "./modules/sqs"
  name        = "nems-queue"
  count       = local.is_sandbox ? 0 : 1
  environment = var.environment
  owner       = var.owner
}

module "sqs-lg-bulk-upload-metadata-queue" {
  source               = "./modules/sqs"
  name                 = "lg-bulk-upload-metadata-queue.fifo"
  max_message          = 256 * 1024        # allow message size up to 256 KB
  message_retention    = 60 * 60 * 24 * 14 # 14 days
  environment          = var.environment
  owner                = var.owner
  max_visibility       = 1020
  enable_fifo          = true
  enable_deduplication = true
  delay                = 60
}

module "sqs-lg-bulk-upload-invalid-queue" {
  source            = "./modules/sqs"
  name              = "lg-bulk-upload-invalid-queue"
  max_message       = 256 * 1024        # 256 KB
  message_retention = 60 * 60 * 24 * 14 # 14 days
  environment       = var.environment
  owner             = var.owner
  max_visibility    = 1020
}

module "sqs-nems-queue-topic" {
  count                 = local.is_sandbox ? 0 : 1
  source                = "./modules/sns"
  sns_encryption_key_id = module.sns_encryption_key.id
  current_account_id    = data.aws_caller_identity.current.account_id
  topic_name            = "nems-queue-topic"
  topic_protocol        = "sqs"
  depends_on            = [module.sqs-nems-queue, module.sns_encryption_key]
  topic_endpoint        = module.sqs-nems-queue[0].endpoint
  delivery_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudwatch.amazonaws.com"
        },
        "Action" : [
          "SNS:Publish",
        ],
        "Condition" : {
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:cloudwatch:eu-west-2:${data.aws_caller_identity.current.account_id}:alarm:*"
          }
        }
        "Resource" : "*"
      }
    ]
  })
}

module "mesh_sns_queue" {
  source             = "./modules/sns"
  count                 = local.is_sandbox ? 0 : 1
  sns_encryption_key_id = module.sns_encryption_key.id
  current_account_id = data.aws_caller_identity.current.account_id
  depends_on            = [module.sqs-nems-queue, module.sns_encryption_key]
  topic_endpoint        = module.sqs-nems-queue[0].endpoint
  topic_name            = "nems_events_topic"
  topic_protocol        = "sqs"
  delivery_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudwatch.amazonaws.com"
        },
        "Action" : [
          "SNS:Publish",
        ],
        "Condition" : {
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:cloudwatch:eu-west-2:${data.aws_caller_identity.current.account_id}:alarm:*"
          }
        }
        "Resource" : "*"
      }
    ]
  })
}