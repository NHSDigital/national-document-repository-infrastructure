module "bulk-upload-lambda" {
  source  = "./modules/lambda"
  name    = "BulkUploadLambda"
  handler = "handlers.bulk_upload_handler.lambda_handler"
  iam_role_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
    module.ndr-bulk-staging-store.s3_object_access_policy,
    module.sqs-lg-bulk-upload-metadata-queue.sqs_policy,
    module.sqs-lg-bulk-upload-invalid-queue.sqs_policy
  ]
  rest_api_id       = null
  api_execution_arn = null
  lambda_environment_variables = {
    WORKSPACE                  = terraform.workspace
    STAGING_STORE_BUCKET_NAME  = "${terraform.workspace}-${var.staging_store_bucket_name}"
    METADATA_SQS_QUEUE_URL     = module.sqs-lg-bulk-upload-metadata-queue.sqs_url
    INVALID_SQS_QUEUE_URL      = module.sqs-lg-bulk-upload-invalid-queue.sqs_url
    LLOYD_GEORGE_BUCKET_NAME   = "${terraform.workspace}-${var.lloyd_george_bucket_name}"
    LLOYD_GEORGE_DYNAMODB_NAME = "${terraform.workspace}_${var.lloyd_george_dynamodb_table_name}"
  }

  is_gateway_integration_needed = false

  depends_on = [
    module.ndr-bulk-staging-store,
    module.sqs-lg-bulk-upload-metadata-queue,
    module.sqs-lg-bulk-upload-invalid-queue
  ]
}


resource "aws_lambda_event_source_mapping" "bulk_upload_lambda" {
  event_source_arn = module.sqs-lg-bulk-upload-metadata-queue.endpoint
  function_name    = module.bulk-upload-lambda.endpoint
  depends_on = [
    module.bulk-upload-lambda,
    module.sqs-lg-bulk-upload-metadata-queue
  ]
}