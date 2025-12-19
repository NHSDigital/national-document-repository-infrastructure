module "report-orchestration-lambda" {
  source         = "./modules/lambda"
  name           = "reportOrchestration"
  handler        = "handlers.report_orchestration_handler.lambda_handler"
  lambda_timeout = 900
  memory_size    = 1769

  iam_role_policy_documents = [
    module.bulk_upload_report_dynamodb_table.dynamodb_read_policy_document,
    module.bulk_upload_report_dynamodb_table.dynamodb_write_policy_document,
    data.aws_iam_policy.aws_lambda_vpc_access_execution_role.policy,
  ]

  lambda_environment_variables = {
    APPCONFIG_APPLICATION         = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT         = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION       = module.ndr-app-config.app_config_configuration_profile_id
    WORKSPACE                     = terraform.workspace
    BULK_UPLOAD_REPORT_TABLE_NAME = "${terraform.workspace}_BulkUploadReport"
  }

  rest_api_id                   = null
  api_execution_arn             = null
  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false

  depends_on = [
    module.bulk_upload_report_dynamodb_table
  ]
}