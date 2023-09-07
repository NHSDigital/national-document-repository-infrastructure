module "authoriser-lambda" {
  source  = "./modules/lambda"
  name    = "AuthoriserLambda"
  handler = "handlers.authoriser_handler.lambda_handler"
  iam_role_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
    module.cis2_auth_session.dynamodb_policy
  ]
  rest_api_id       = aws_api_gateway_rest_api.ndr_doc_store_api.id
  api_execution_arn = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  lambda_environment_variables = {
    WORKSPACE         = terraform.workspace
    DYNAMODB_ENDPOINT = var.cis2_auth_session_table_name
  }
  http_method = "GET"
  resource_id = ""
}

resource "aws_api_gateway_authorizer" "repo_authoriser" {
  name            = "${terraform.workspace}_repo_authoriser"
  type            = "TOKEN"
  identity_source = "method.request.header.Authorization"
  rest_api_id     = aws_api_gateway_rest_api.ndr_doc_store_api.id
  authorizer_uri  = module.authoriser-lambda.invoke_arn
  #   authorizer_credentials           = aws_iam_role.authoriser_execution.arn
}
