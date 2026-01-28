module "ses-feedback-monitor-lambda" {
  source         = "./modules/lambda"
  name           = "SesFeedbackMonitor"
  handler        = "handlers.ses_feedback_monitor_handler.lambda_handler"
  lambda_timeout = 60
  memory_size    = 512

  iam_role_policy_documents = [
    data.aws_iam_policy_document.ses_feedback_s3_put.json,
    data.aws_iam_policy_document.reporting_ses.json,
    data.aws_iam_policy.aws_lambda_vpc_access_execution_role.policy,
  ]

  lambda_environment_variables = {
    APPCONFIG_APPLICATION   = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT   = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION = module.ndr-app-config.app_config_configuration_profile_id
    WORKSPACE               = terraform.workspace

    SES_FEEDBACK_BUCKET_NAME = module.ses-feedback-store.bucket_id
    SES_FEEDBACK_PREFIX      = "ses-feedback/"
    PRM_MAILBOX_EMAIL        = data.aws_ssm_parameter.prm_mailbox_email.value
    SES_FROM_ADDRESS         = local.reporting_ses_from_address_value
    ALERT_ON_EVENT_TYPES     = "BOUNCE,REJECT"
  }

  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false

  depends_on = [
    module.ses-feedback-store
  ]
}
