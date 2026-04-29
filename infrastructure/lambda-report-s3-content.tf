module "report-s3-content-lambda" {
  source         = "./modules/lambda"
  name           = "ReportS3Content"
  handler        = "handlers.report_s3_content_handler.lambda_handler"
  lambda_timeout = 900
  memory_size    = 10240 #max memory size

  iam_role_policy_documents = [
    module.ndr-bulk-staging-store.s3_read_policy_document,
    module.statistical-reports-store.s3_read_policy_document,
    module.statistical-reports-store.s3_write_policy_document,
  ]

  lambda_environment_variables = {
    WORKSPACE                  = terraform.workspace
    STATISTICAL_REPORTS_BUCKET = "${terraform.workspace}-${var.statistical_reports_bucket_name}"
    BULK_STAGING_BUCKET_NAME   = "${terraform.workspace}-${var.staging_store_bucket_name}"
  }

  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false
}

