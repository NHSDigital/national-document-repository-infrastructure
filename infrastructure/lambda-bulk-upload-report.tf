module "bulk-upload-report-lambda" {
  source  = "./modules/lambda"
  name    = "BulkUploadReportLambda"
  handler = "handlers.bulk_upload_report_handler.lambda_handler"
  iam_role_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
    module.ndr-bulk-staging-store.s3_object_access_policy,
  ]
  rest_api_id       = aws_api_gateway_rest_api.ndr_doc_store_api.id
  api_execution_arn = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  lambda_environment_variables = {
    WORKSPACE                 = terraform.workspace
    STAGING_STORE_BUCKET_NAME = "${terraform.workspace}-${var.staging_store_bucket_name}"
  }
  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false

  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
    module.ndr-bulk-staging-store,
  ]
}