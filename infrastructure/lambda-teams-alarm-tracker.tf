resource "aws_api_gateway_resource" "teams_alarm_tracker" {
  rest_api_id = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id   = aws_api_gateway_rest_api.ndr_doc_store_api.root_resource_id
  path_part   = "teams"
}

resource "aws_api_gateway_method" "teams_alarm_tracker" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.teams_alarm_tracker.id
  rest_api_id   = aws_api_gateway_rest_api.ndr_doc_store_api.id
}

module "teams-alarm-tracker-lambda" {
  source         = "./modules/lambda"
  name           = "TeamsAlarmTracker"
  handler        = "handlers.teams_alarm_tracker.lambda_handler"
  lambda_timeout = 600
  iam_role_policy_documents = [
    module.ndr-app-config.app_config_policy,
    aws_iam_policy.ssm_access_policy.policy
  ]
  rest_api_id       = aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id       = aws_api_gateway_resource.teams_alarm_tracker.id
  http_methods      = ["POST"]
  api_execution_arn = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  lambda_environment_variables = {
    APPCONFIG_APPLICATION   = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT   = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION = module.ndr-app-config.app_config_configuration_profile_id
    WORKSPACE               = terraform.workspace
  }
  depends_on = [aws_api_gateway_method.teams_alarm_tracker]
}