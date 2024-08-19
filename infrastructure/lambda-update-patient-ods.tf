module "update-patient-ods-lambda" {
  source  = "./modules/lambda"
  name    = "UpdatePatientOdsLambda"
  handler = "handlers.update_patient_ods_handler.lambda_handler"
  iam_role_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
    module.lloyd_george_reference_dynamodb_table.dynamodb_policy,
    module.ndr-app-config.app_config_policy_arn,
    aws_iam_policy.ssm_access_policy.arn
  ]
  rest_api_id       = null
  api_execution_arn = null

  lambda_environment_variables = {
    APPCONFIG_APPLICATION      = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT      = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION    = module.ndr-app-config.app_config_configuration_profile_id
    WORKSPACE                  = terraform.workspace
    LLOYD_GEORGE_DYNAMODB_NAME = "${terraform.workspace}_${var.lloyd_george_dynamodb_table_name}"
    PDS_FHIR_IS_STUBBED        = local.is_sandbox
  }
  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false
  memory_size                   = 512
  lambda_timeout                = 900

  depends_on = [
    module.lloyd_george_reference_dynamodb_table,
    aws_iam_policy.ssm_access_policy,
    module.ndr-app-config
  ]
}

module "update-patient-ods-alarm" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.update-patient-ods-lambda.function_name
  lambda_timeout       = module.update-patient-ods-lambda.timeout
  lambda_name          = "update_patient_ods_handler"
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.update-patient-ods-alarm-topic.arn]
  ok_actions           = [module.update-patient-ods-alarm-topic.arn]
  depends_on           = [module.update-patient-ods-lambda, module.update-patient-ods-alarm-topic]
}

module "update-patient-ods-alarm-topic" {
  source                = "./modules/sns"
  sns_encryption_key_id = module.sns_encryption_key.id
  current_account_id    = data.aws_caller_identity.current.account_id
  topic_name            = "update-patient-ods--topic"
  topic_protocol        = "lambda"
  topic_endpoint        = module.update-patient-ods-lambda.lambda_arn
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

  depends_on = [module.update-patient-ods-lambda, module.sns_encryption_key]
}