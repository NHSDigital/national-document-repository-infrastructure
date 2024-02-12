module "feature-flags-gateway" {
  # Gateway Variables
  source              = "./modules/gateway"
  api_gateway_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id           = aws_api_gateway_rest_api.ndr_doc_store_api.root_resource_id
  http_method         = "GET"
  authorization       = "CUSTOM"
  gateway_path        = "FeatureFlags"
  authorizer_id       = aws_api_gateway_authorizer.repo_authoriser.id
  require_credentials = true
  origin              = "'https://${terraform.workspace}.${var.domain}'"

  # Lambda Variables
  api_execution_arn = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  owner             = var.owner
  environment       = var.environment

  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
  ]
}

module "feature_flags_alarm" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.feature-flags-lambda.function_name
  lambda_timeout       = module.feature-flags-lambda.timeout
  lambda_name          = "feature_flags_handler"
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.feature_flags_alarm_topic.arn]
  ok_actions           = [module.feature_flags_alarm_topic.arn]
  depends_on           = [module.feature-flags-lambda, module.feature_flags_alarm_topic]
}


module "feature_flags_alarm_topic" {
  source                = "./modules/sns"
  sns_encryption_key_id = module.sns_encryption_key.id
  current_account_id    = data.aws_caller_identity.current.account_id
  topic_name            = "feature_flags_alarms-topic"
  topic_protocol        = "lambda"
  topic_endpoint        = module.feature-flags-lambda.endpoint
  depends_on            = [module.sns_encryption_key]
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

module "feature-flags-lambda" {
  source  = "./modules/lambda"
  name    = "FeatureFlagsLambda"
  handler = "handlers.feature_flags_handler.lambda_handler"
  iam_role_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
    aws_iam_policy.app_config_policy.arn
  ]
  rest_api_id       = aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id       = module.feature-flags-gateway.gateway_resource_id
  http_method       = "GET"
  api_execution_arn = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn

  memory_size    = 512
  lambda_timeout = 450

  lambda_environment_variables = {
    APPCONFIG_APPLICATION   = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT   = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION = module.ndr-app-config.app_config_configuration_profile_id
    WORKSPACE               = terraform.workspace
  }

  layers = [
    "arn:aws:lambda:${local.current_region}:${local.current_account_id}:layer:AWS-AppConfig-Extension:81"
  ]

  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
    module.ndr-app-config,
    module.feature-flags-gateway,
    aws_iam_policy.lambda_audit_splunk_sqs_queue_send_policy[0]
  ]
}

resource "aws_iam_policy" "app_config_policy" {
  name = "${terraform.workspace}_app_config_lambda"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "appconfig:GetLatestConfiguration",
          "appconfig:StartConfigurationSession"
        ],
        Resource = [
          "arn:aws:appconfig:*:*:application/${module.ndr-app-config.app_config_application_id}/environment/${module.ndr-app-config.app_config_environment_id}/configuration/${module.ndr-app-config.app_config_configuration_profile_id}"
        ]
      }
    ]
  })
}