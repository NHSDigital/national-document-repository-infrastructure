module "search-user-restriction-lambda" {
  source  = "./modules/lambda"
  name    = "SearchUserRestriction"
  handler = "handlers.search_user_restriction_handler.lambda_handler"
  iam_role_policy_documents = [
    module.ndr-app-config.app_config_policy,
    aws_iam_policy.ssm_access_policy.policy,
    module.user_restriction_table.dynamodb_write_policy_document
  ]
  kms_deletion_window = var.kms_deletion_window
  rest_api_id         = aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id         = module.user_restrictions_gateway.gateway_resource_id
  http_methods        = ["GET"]
  api_execution_arn   = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  lambda_environment_variables = {
    APPCONFIG_APPLICATION   = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT   = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION = module.ndr-app-config.app_config_configuration_profile_id
    WORKSPACE               = terraform.workspace
    RESTRICTIONS_TABLE_NAME = module.user_restriction_table.table_name
  }

  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
    module.user_restrictions_gateway
  ]
}

module "search-user-restriction-lambda-alarms" {
  source               = "./modules/lambda_alarms"
  lambda_timeout       = module.search-user-restriction-lambda.timeout
  lambda_function_name = module.search-user-restriction-lambda.function_name
  lambda_name          = module.search-user-restriction-lambda.function_name
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.search-user-restriction-lambda-alarm-topic.arn]
  ok_actions           = [module.search-user-restriction-lambda-alarm-topic.arn]
}

module "search-user-restriction-lambda-alarm-topic" {
  source                 = "./modules/sns"
  sns_encryption_key_id  = module.sns_encryption_key.id
  topic_name             = "search-user-restriction-lambda-alarm-topic"
  topic_protocol         = "email"
  is_topic_endpoint_list = true
  topic_endpoint_list    = local.is_sandbox ? [] : nonsensitive(split(",", data.aws_ssm_parameter.cloud_security_notification_email_list.value))
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
