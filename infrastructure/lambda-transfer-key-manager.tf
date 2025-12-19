module "transfer-key-manager-lambda" {
  source         = "./modules/lambda"
  name           = "TransferKeyManagerLambda"
  handler        = "handlers.transfer_key_manager_handler.lambda_handler"
  lambda_timeout = 300

  iam_role_policy_documents = [
    data.aws_iam_policy_document.transfer_key_manager_policy.json,
    module.ndr-app-config.app_config_policy
  ]

  kms_deletion_window = var.kms_deletion_window
  rest_api_id         = null
  api_execution_arn   = null

  lambda_environment_variables = {
    APPCONFIG_APPLICATION   = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT   = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION = module.ndr-app-config.app_config_configuration_profile_id
    WORKSPACE               = terraform.workspace
    PRM_MAILBOX_EMAIL       = data.aws_ssm_parameter.prm_mailbox_email.value
    DRY_RUN                 = tostring(var.ssh_key_management_dry_run)
  }

  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false
}

data "aws_ssm_parameter" "prm_mailbox_email" {
  name = "/prs/${var.environment}/user-input/prm-mailbox-email"
}

data "aws_iam_policy_document" "transfer_key_manager_policy" {
  statement {
    sid    = "TransferFamilyAccess"
    effect = "Allow"
    actions = [
      "transfer:ListServers",
      "transfer:ListUsers",
      "transfer:DescribeUser",
      "transfer:DeleteSshPublicKey"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "SESAccess"
    effect = "Allow"
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "ses:FromAddress"
      values   = [data.aws_ssm_parameter.prm_mailbox_email.value]
    }
  }

  statement {
    sid    = "CloudWatchMetrics"
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "cloudwatch:namespace"
      values   = ["SSHKeyManagement"]
    }
  }
}

module "transfer-key-manager-alarm" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.transfer-key-manager-lambda.function_name
  lambda_timeout       = module.transfer-key-manager-lambda.timeout
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.transfer-key-manager-alarm-topic.arn]
  ok_actions           = [module.transfer-key-manager-alarm-topic.arn]
  depends_on           = [module.transfer-key-manager-lambda, module.transfer-key-manager-alarm-topic]
}

module "transfer-key-manager-alarm-topic" {
  source                = "./modules/sns"
  sns_encryption_key_id = module.sns_encryption_key.id
  topic_name            = "transfer-key-manager-topic"
  topic_protocol        = "lambda"
  topic_endpoint        = module.transfer-key-manager-lambda.lambda_arn
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

  depends_on = [module.transfer-key-manager-lambda, module.sns_encryption_key]
}
