resource "aws_api_gateway_resource" "token_request_resource" {
  rest_api_id = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id   = aws_api_gateway_rest_api.ndr_doc_store_api.root_resource_id
  path_part   = "TokenRequest"
}

resource "aws_api_gateway_method" "token_request_proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id   = aws_api_gateway_resource.token_request_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

module "create-token-lambda" {
  source  = "./modules/lambda"
  name    = "TokenRequestHandler"
  handler = "handlers.token_handler.lambda_handler"
  iam_role_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
    aws_iam_policy.ssm_policy_token.arn
  ]
  rest_api_id                  = aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id                  = module.create-doc-ref-gateway.gateway_resource_id
  http_method                  = "POST"
  api_execution_arn            = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  lambda_environment_variables = {}
  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
  ]
}

resource "aws_iam_policy" "ssm_policy_token" {
  name = "${terraform.workspace}_ssm_token_private_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "ssm:GetParametersByPath"
        ],
        Resource = [
          "arn:aws:ssm:*:*:parameter/jwt_token_private_key",
        ]
      }
    ]
  })
}