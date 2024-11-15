data "aws_ssm_parameter" "mns_lambda_role" {
  name = "/ndr/${var.environment}/mns/lambda_role"
}

data "aws_ssm_parameter" "mns_sns" {
  name = "/ndr/${var.environment}/mns/sns_resource"
}

module "mns_encryption_key" {
  source                = "./modules/kms"
  kms_key_name          = "alias/mns-notification-encryption-key-kms-${terraform.workspace}"
  kms_key_description   = "Custom KMS Key to enable server side encryption for mns subscriptions"
  current_account_id    = data.aws_caller_identity.current.account_id
  environment           = var.environment
  owner                 = var.owner
  service_identifiers   = ["sns.amazonaws.com"]
  aws_identifiers       = [data.aws_ssm_parameter.mns_lambda_role.value]
  allow_decrypt_for_arn = true
  allowed_arn           = data.aws_ssm_parameter.mns_sns.value
}

module "sqs-mns-notification-queue" {
  source            = "./modules/sqs"
  name              = "mns-notification-queue"
  max_size_message  = 256 * 1024        # allow message size up to 256 KB
  message_retention = 60 * 60 * 24 * 14 # 14 days
  environment       = var.environment
  owner             = var.owner
  max_visibility    = 1020
  delay             = 60
  kms_master_key_id = module.mns_encryption_key.id
  enable_sse        = False
}

resource "aws_iam_policy" "mns_sqs_access_policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" = "Allow",
        "Action" = [
          "sqs:SendMessage",
        ],
        "Resource" = [
          module.sqs-mns-notification-queue.sqs_arn
        ],
        "Principal" = {
          "Type"        = "Service",
          "Identifiers" = ["sns.amazonaws.com"],
        },
        "Condition" = {
          "aws:SourceArn" = data.aws_ssm_parameter.mns_sns.value
        }
      },
      {
        "Effect" = "Allow",
        "Action" = [
          "sqs:SendMessage",
        ],
        "Resource" = [
          module.sqs-mns-notification-queue.sqs_arn
        ],
        "Principal" = {
          "Type"        = "AWS",
          "Identifiers" = [data.aws_ssm_parameter.mns_lambda_role.value],
        },
      }
    ]
  })
}
