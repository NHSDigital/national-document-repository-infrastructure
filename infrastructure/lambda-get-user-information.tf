module "get_user_information_lambda" {
  source  = "./modules/lambda"
  name    = "GetUserInformation"
  handler = "handlers.get_user_information_handler.lambda_handler"
  iam_role_policy_documents = [
    module.ndr-app-config.app_config_policy,
    aws_iam_policy.ssm_access_policy.policy,
  ]
  kms_deletion_window = var.kms_deletion_window
  rest_api_id         = aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id         = module.user_restrictions_user_search_gateway.gateway_resource_id
  http_methods        = ["GET"]
  api_execution_arn   = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  lambda_environment_variables = {
    APPCONFIG_APPLICATION       = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT       = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION     = module.ndr-app-config.app_config_configuration_profile_id
    WORKSPACE                   = terraform.workspace
    USE_MOCK_HEALTHCARE_SERVICE = true
    HEALTHCARE_WORKER_API_URL   = module.healthcare_worker_api_base_url[0].ssm_value
  }

  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
    module.user_restrictions_user_search_gateway
  ]
}

module "get_user_information_lambda_alarms" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.get_user_information_lambda.function_name
  lambda_timeout       = module.get_user_information_lambda.timeout
  lambda_name          = module.get_user_information_lambda.function_name
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.get_user_information_lambda_alarm_topic.arn]
  ok_actions           = [module.get_user_information_lambda_alarm_topic.arn]
}

module "get_user_information_lambda_alarm_topic" {
  source                 = "./modules/sns"
  sns_encryption_key_id  = module.sns_encryption_key.id
  topic_name             = "get-user-information-lambda-alarm-topic"
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