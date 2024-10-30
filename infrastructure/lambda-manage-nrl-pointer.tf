module "manage-nrl-pointer-lambda" {
  count          = 1
  source         = "./modules/lambda"
  name           = "ManageNrlPointerLambda"
  handler        = "handlers.manage_nrl_pointer_handler.lambda_handler"
  lambda_timeout = 600
  iam_role_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
    module.ndr-app-config.app_config_policy_arn
  ]
  rest_api_id       = null
  api_execution_arn = null

  lambda_environment_variables = {
    APPCONFIG_APPLICATION   = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT   = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION = module.ndr-app-config.app_config_configuration_profile_id
    WORKSPACE               = terraform.workspace
  }
  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false

  depends_on = [
    module.ndr-app-config
  ]
}

module "manage-nrl-pointer-alarm" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.manage-nrl-pointer-lambda.function_name
  lambda_timeout       = module.manage-nrl-pointer-lambda.timeout
  lambda_name          = "manage_nrl_pointer_handler"
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.manage-nrl-pointer-alarm-topic.arn]
  ok_actions           = [module.manage-nrl-pointer-alarm-topic.arn]
  depends_on           = [module.manage-nrl-pointer-lambda, module.manage-nrl-pointer-alarm-topic]
}

module "manage-nrl-pointer-alarm-topic" {
  source                = "./modules/sns"
  sns_encryption_key_id = module.sns_encryption_key.id
  current_account_id    = data.aws_caller_identity.current.account_id
  topic_name            = "bulk-upload-topic"
  topic_protocol        = "lambda"
  topic_endpoint        = module.manage-nrl-pointer-lambda.lambda_arn
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

  depends_on = [module.bulk-upload-lambda, module.sns_encryption_key]
}