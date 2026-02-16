
module "delete-document-references-fhir-lambda" {
  source  = "./modules/lambda"
  name    = "DeleteDocumentReferencesFHIR"
  handler = "handlers.delete_fhir_document_reference_handler.lambda_handler"
  iam_role_policy_documents = [
    module.ndr-app-config.app_config_policy,
    module.lloyd_george_reference_dynamodb_table.dynamodb_read_policy_document,
    module.core_dynamodb_table.dynamodb_read_policy_document,
    module.lloyd_george_reference_dynamodb_table.dynamodb_write_policy_document,
    module.core_dynamodb_table.dynamodb_write_policy_document,
    aws_iam_policy.ssm_access_policy.policy,
    aws_iam_policy.mtls_access_ssm_policy.policy,
    module.pdm-document-store.s3_read_policy_document,
    module.ndr-lloyd-george-store.s3_read_policy_document,
    module.pdm-document-store.s3_write_policy_document,
    module.ndr-lloyd-george-store.s3_write_policy_document,
    module.document_reference_dynamodb_table.dynamodb_read_policy_document,
    module.document_reference_dynamodb_table.dynamodb_write_policy_document,
    module.ndr-document-store.s3_read_policy_document,
    module.ndr-document-store.s3_write_policy_document,
    module.stitch_metadata_reference_dynamodb_table.dynamodb_read_policy_document,
    module.stitch_metadata_reference_dynamodb_table.dynamodb_write_policy_document,
    module.sqs-nrl-queue.sqs_read_policy_document,
    module.sqs-nrl-queue.sqs_write_policy_document,
    module.unstitched_lloyd_george_reference_dynamodb_table.dynamodb_write_policy_document,
    module.unstitched_lloyd_george_reference_dynamodb_table.dynamodb_read_policy_document
  ]
  kms_deletion_window = var.kms_deletion_window
  rest_api_id         = aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id         = module.fhir_document_reference_gateway[0].gateway_resource_id
  http_methods        = ["DELETE"]
  api_execution_arn   = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  lambda_environment_variables = {
    APPCONFIG_APPLICATION                 = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT                 = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION               = module.ndr-app-config.app_config_configuration_profile_id
    WORKSPACE                             = terraform.workspace
    ENVIRONMENT                           = var.environment
    LLOYD_GEORGE_BUCKET_NAME              = "${terraform.workspace}-${var.lloyd_george_bucket_name}"
    LLOYD_GEORGE_DYNAMODB_NAME            = "${terraform.workspace}_${var.lloyd_george_dynamodb_table_name}"
    DOCUMENT_STORE_DYNAMODB_NAME          = "${terraform.workspace}_${var.docstore_dynamodb_table_name}"
    STITCH_METADATA_DYNAMODB_NAME         = "${terraform.workspace}_${var.stitch_metadata_dynamodb_table_name}"
    UNSTITCHED_LLOYD_GEORGE_DYNAMODB_NAME = "${terraform.workspace}_${var.unstitched_lloyd_george_dynamodb_table_name}"
    NRL_SQS_QUEUE_URL                     = module.sqs-nrl-queue.sqs_url
  }
  depends_on = [
    module.lloyd_george_reference_dynamodb_table,
    module.core_dynamodb_table,
    aws_api_gateway_rest_api.ndr_doc_store_api,
    module.document_reference_dynamodb_table,
    module.stitch_metadata_reference_dynamodb_table,
    module.ndr-app-config
  ]
}

resource "aws_lambda_permission" "lambda_permission_delete_mtls_api" {
  statement_id  = "AllowAPImTLSGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.delete-document-references-fhir-lambda.lambda_arn
  principal     = "apigateway.amazonaws.com"
  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.ndr_doc_store_api_mtls.execution_arn}/*/*"
}

resource "aws_api_gateway_integration" "delete_document_references_fhir_lambda" {
  rest_api_id = aws_api_gateway_rest_api.ndr_doc_store_api_mtls.id
  resource_id = module.fhir_document_reference_mtls_gateway.gateway_resource_id
  http_method = "DELETE"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.delete-document-references-fhir-lambda.invoke_arn
  depends_on              = [module.fhir_document_reference_mtls_gateway]
}
