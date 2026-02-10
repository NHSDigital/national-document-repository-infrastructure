module "report-s3-content-lambda" {
  source         = "./modules/lambda"
  name           = "ReportS3Content"
  handler        = "handlers.report_s3_content_handler.lambda_handler"
  lambda_timeout = 900
  memory_size    = 10240 #max memory size

  iam_role_policy_documents = [
    module.ndr-bulk-staging-store.s3_read_policy_document,
    module.ndr-lloyd-george-store.s3_read_policy_document,
    module.statistical-reports-store.s3_read_policy_document,
    module.statistical-reports-store.s3_write_policy_document,
    module.ndr-app-config.app_config_policy,
  ]

  lambda_environment_variables = {
    APPCONFIG_APPLICATION      = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT      = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION    = module.ndr-app-config.app_config_configuration_profile_id
    WORKSPACE                  = terraform.workspace
    STATISTICAL_REPORTS_BUCKET = "${terraform.workspace}-${var.statistical_reports_bucket_name}"
    BULK_STAGING_BUCKET_NAME   = "${terraform.workspace}-${var.staging_store_bucket_name}"
    LLOYD_GEORGE_BUCKET_NAME   = "${terraform.workspace}-${var.lloyd_george_bucket_name}"
  }

  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false
}

