module "document-manifest-by-nhs-gateway" {
  # Gateway Variables
  source                   = "./modules/gateway"
  api_gateway_id           = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id                = aws_api_gateway_rest_api.ndr_doc_store_api.root_resource_id
  http_method              = "GET"
  authorization            = "NONE" // "CUSTOM"
  gateway_path             = "DocumentManfiestByNHSNumber"
  authorizer_id            = null
  cors_require_credentials = var.cors_require_credentials
  origin                   = "'https://${terraform.workspace}.${var.domain}'"

  # Lambda Variables
  api_execution_arn = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  owner             = var.owner
  environment       = var.environment

  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
  ]
}

module "document-manifest-by-nhs-number-lambda" {
  source  = "./modules/lambda"
  name    = "DocumentManifestByNHSNumberLambda"
  handler = "handlers.document_manifest_by_nhs_number_handler.lambda_handler"
  iam_role_policies = [
    module.document_reference_dynamodb_table.dynamodb_policy,
    module.lloyd_george_reference_dynamodb_table.dynamodb_policy,
    module.ndr-document-store.s3_object_access_policy,
    module.ndr-lloyd-george-store.s3_object_access_policy,
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
  ]
  rest_api_id       = aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id       = module.document-manifest-by-nhs-gateway.gateway_resource_id
  http_method       = "GET"
  api_execution_arn = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  lambda_environment_variables = {
    DOCUMENT_STORE_BUCKET_NAME   = "${terraform.workspace}-${var.docstore_bucket_name}"
    LLOYD_GEORGE_BUCKET_NAME     = "${terraform.workspace}-${var.lloyd_george_bucket_name}"
    DOCUMENT_STORE_DYNAMODB_NAME = "${terraform.workspace}_${var.docstore_dynamodb_table_name}"
    LLOYD_GEORGE_DYNAMODB_NAME   = "${terraform.workspace}_${var.lloyd_george_dynamodb_table_name}"
  }
  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
    module.document-manifest-by-nhs-gateway,
  ]
}
