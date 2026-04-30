module "report-orchestration-lambda" {
  source         = "./modules/lambda"
  name           = "ReportOrchestration"
  handler        = "handlers.report_orchestration_handler.lambda_handler"
  lambda_timeout = 900

  iam_role_policy_documents = [
    module.bulk_upload_report_dynamodb_table.dynamodb_read_policy_document,
    module.bulk_upload_report_dynamodb_table.dynamodb_write_policy_document,
    module.ndr-report-store.s3_write_policy_document,
    data.aws_iam_policy.aws_lambda_vpc_access_execution_role.policy,
  ]

  lambda_environment_variables = {
    WORKSPACE                     = terraform.workspace
    BULK_UPLOAD_REPORT_TABLE_NAME = "${terraform.workspace}_BulkUploadReport"
    REPORT_BUCKET_NAME            = module.ndr-report-store.bucket_id
  }

  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false
}
