module "create-doc-ref-gateway" {
  # Gateway Variables
  source                   = "./modules/gateway"
  api_gateway_id           = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id                = aws_api_gateway_rest_api.ndr_doc_store_api.root_resource_id
  http_method              = "POST"
  authorization            = "NONE" // "CUSTOM"
  gateway_path             = "DocumentReference"
  authorizer_id            = null
  cors_require_credentials = var.cors_require_credentials
  origin                   = "'https://${terraform.workspace}.${var.domain}'"

  # Lambda Variables
  docstore_bucket_name = var.docstore_bucket_name
  api_execution_arn    = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  owner                = var.owner
  environment          = var.environment

  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
  ]
}

module "create-doc-ref-lambda" {
  source               = "./modules/lambda"
  name                 = "CreateDocRefLambda"
  handler              = "lambda_create_document_reference.lambda_handler"
  docstore_bucket_name = var.docstore_bucket_name
  iam_role_policies = [
    module.document_reference_dynamodb_table.dynamodb_policy,
    module.ndr-document-store.s3_object_access_policy,
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
  ]
  rest_api_id       = aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id       = module.create-doc-ref-gateway.gateway_resource_id
  http_method       = "POST"
  api_execution_arn = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  lambda_environment_variables = {
    DOCUMENT_STORE_BUCKET_NAME   = "${terraform.workspace}-${var.docstore_bucket_name}"
    DOCUMENT_STORE_DYNAMODB_NAME = "${terraform.workspace}_DocumentReferenceMetadata"
  }
  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
    module.document_reference_dynamodb_table,
    module.create-doc-ref-gateway
  ]
}
