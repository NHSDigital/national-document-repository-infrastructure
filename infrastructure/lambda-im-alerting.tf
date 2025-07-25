resource "aws_ssm_parameter" "im_alerting_teams_webhook_url" {
  name        = "/ndr/${terraform.workspace}/alerting/teams/webhook_url"
  type        = "String"
  description = "Teams webhook URL used for instant message alerting"
  value       = var.teams_alerting_webhook_url

  tags = {
    Owner       = var.owner
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "im_alerting_confluence_base_url" {
  name        = "/ndr/${terraform.workspace}/alerting/confluence/url"
  type        = "String"
  description = "Confluence base URL for finding out what to do when an alarm goes off"
  value       = var.im_alerting_confluence_url

  tags = {
    Owner       = var.owner
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "im_alerting_slack_channel_id" {
  name        = "/ndr/${terraform.workspace}/alerting/slack/channel_id"
  type        = "String"
  description = "Destination channel ID for slack alerts"
  value       = var.slack_alerting_channel_id

  tags = {
    Owner       = var.owner
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "im_alerting_slack_bot_token" {
  name        = "/ndr/${terraform.workspace}/alerting/slack/bot_token"
  type        = "String"
  description = "Slack bot token used for the IM Alerting lambda"
  value       = var.slack_alerting_bot_token

  tags = {
    Owner       = var.owner
    Environment = var.environment
  }
}

module "im-alerting-lambda" {
  source  = "./modules/lambda"
  name    = "IMAlertingLambda"
  handler = "handlers.im_alerting_handler.lambda_handler"
  iam_role_policy_documents = [
    aws_iam_policy.ssm_access_policy.policy,
    aws_iam_policy.alerting_lambda_alarms.policy,
    aws_iam_policy.alerting_lambda_tags.policy,
    module.ndr-app-config.app_config_policy,
    module.alarm_state_history_table.dynamodb_read_policy_document,
    module.alarm_state_history_table.dynamodb_write_policy_document
  ]
  rest_api_id       = null
  api_execution_arn = null
  lambda_environment_variables = {
    APPCONFIG_APPLICATION       = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT       = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION     = module.ndr-app-config.app_config_configuration_profile_id
    WORKSPACE                   = terraform.workspace
    TEAMS_WEBHOOK_URL           = aws_ssm_parameter.im_alerting_teams_webhook_url.value
    CONFLUENCE_BASE_URL         = aws_ssm_parameter.im_alerting_confluence_base_url.value
    ALARM_HISTORY_DYNAMODB_NAME = module.alarm_state_history_table.table_name
    SLACK_CHANNEL_ID            = aws_ssm_parameter.im_alerting_slack_channel_id.value
    SLACK_BOT_TOKEN             = aws_ssm_parameter.im_alerting_slack_bot_token.value
  }
  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false
  lambda_timeout                = 900
}


resource "aws_iam_policy" "alerting_lambda_alarms" {
  name        = "${terraform.workspace}_alerting_lambda_alarms_policy"
  description = "Alarms policy to allow lambda to describe all alarms"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudwatch:DescribeAlarms",
          "cloudwatch:ListTagsForResource",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:cloudwatch:${var.region}:${data.aws_caller_identity.current.account_id}:alarm:*"
      },
    ]
  })
}

resource "aws_iam_policy" "alerting_lambda_tags" {
  name        = "${terraform.workspace}_alerting_lambda_tags_policy"
  description = "Tags policy to allow alerting lambda to get resources by tags"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "tag:GetResources"
        ]
        Effect   = "Allow"
        Resource = "*"
    }]
  })
}