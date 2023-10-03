module "logout-gateway" {
  # Gateway Variables
  source                   = "./modules/gateway"
  api_gateway_id           = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id                = aws_api_gateway_rest_api.ndr_doc_store_api.root_resource_id
  http_method              = "GET"
  authorization            = "CUSTOM"
  gateway_path             = "Auth/Logout"
  authorizer_id            = aws_api_gateway_authorizer.repo_authoriser.id
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

module "logout_lambda" {
  source  = "./modules/lambda"
  name    = "LogoutHandler"
  handler = "handlers.logout_handler.lambda_handler"
  iam_role_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
    aws_iam_policy.ssm_policy_oidc.arn,
    module.auth_session_dynamodb_table.dynamodb_policy
  ]
  rest_api_id       = aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id       = module.logout-gateway.gateway_resource_id
  http_method       = "GET"
  api_execution_arn = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  lambda_environment_variables = {
    WORKSPACE                      = terraform.workspace
    AUTH_DYNAMODB_NAME             = "${terraform.workspace}_${var.auth_session_dynamodb_table_name}"
    SSM_PARAM_JWT_TOKEN_PUBLIC_KEY = "jwt_token_public_key"

  }
  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
  module.logout-gateway]
}
