data "aws_ssm_parameter" "teams_alerting_webhook_url" {
  name = "/ndr/${var.environment}/teams/webhook_url"
}

module "teams-alerting-lambda" {
  source  = "./modules/lambda"
  name    = "TeamsAlertingLambda"
  handler = "handlers.teams_alerting_handler.lambda_handler"
  iam_role_policy_documents = [
    aws_iam_policy.ssm_access_policy.policy,
    module.ndr-app-config.app_config_policy,
  ]
  rest_api_id       = null
  api_execution_arn = null
  lambda_environment_variables = {
    APPCONFIG_APPLICATION   = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT   = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION = module.ndr-app-config.app_config_configuration_profile_id
    WORKSPACE               = terraform.workspace
    WEBHOOK_URL             = data.aws_ssm_parameter.teams_alerting_webhook_url.value
  }
  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false
  lambda_timeout                = 900
}


resource "aws_sns_topic_subscription" "teams_alerting" {
  endpoint  = module.teams-alerting-lambda.lambda_arn
  protocol  = "lambda"
  topic_arn = aws_sns_topic.alarm_notifications_topic[0].arn
}

resource "aws_lambda_permission" "invoke_with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = module.teams-alerting-lambda.lambda_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.alarm_notifications_topic[0].arn
}