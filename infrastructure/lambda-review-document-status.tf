module "review-document-status-check-lambda" {
  source  = "./modules/lambda"
  name    = "ReviewDocumentStatusCheck"
  handler = "handlers.review_document_status_check.lambda_handler"
  iam_role_policy_documents = [
    module.ndr-app-config.app_config_policy,
    aws_iam_policy.ssm_access_policy.policy,
    module.document_review_dynamodb_table[0].dynamodb_read_policy_document
  ]
  kms_deletion_window = var.kms_deletion_window
  rest_api_id         = aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id         = module.review-document-status-id-gateway.gateway_resource_id
  http_methods        = ["GET"]
  api_execution_arn   = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  lambda_environment_variables = {
    APPCONFIG_APPLICATION         = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT         = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION       = module.ndr-app-config.app_config_configuration_profile_id
    DOCUMENT_REVIEW_DYNAMODB_NAME = module.document_review_dynamodb_table[0].table_name
    WORKSPACE                     = terraform.workspace
  }
}
