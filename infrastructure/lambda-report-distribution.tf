module "report-distribution-lambda" {
  source         = "./modules/lambda"
  name           = "reportDistribution"
  handler        = "handlers.report_distribution_handler.lambda_handler"
  lambda_timeout = 300
  memory_size    = 2048

  iam_role_policy_documents = [
    module.report-orchestration-store.s3_read_policy_document,

    # To be added on ticket 1128
    # module.report_contact_lookup.dynamodb_read_policy_document,
    # Until the real module exists
    data.aws_iam_policy_document.report_contact_lookup_read_policy.json,

    data.aws_iam_policy_document.reporting_ses_policy.json,
    data.aws_iam_policy.aws_lambda_vpc_access_execution_role.policy,
  ]

  lambda_environment_variables = {
    APPCONFIG_APPLICATION   = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT   = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION = module.ndr-app-config.app_config_configuration_profile_id
    WORKSPACE               = terraform.workspace

    REPORT_BUCKET_NAME = module.report-orchestration-store.bucket_id
    CONTACT_TABLE_NAME = "${terraform.workspace}_ReportContactLookup"

    PRM_MAILBOX_EMAIL = data.aws_ssm_parameter.prm_mailbox_email.value
    SES_FROM_ADDRESS  = aws_ssm_parameter.reporting_ses_from_address.value
  }

  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false

  depends_on = [
    module.report-orchestration-store
  ]
}
