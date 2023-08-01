resource "aws_api_gateway_resource" "gateway_resource" {
  rest_api_id = var.api_gateway_id
  parent_id   = var.parent_id
  path_part   = var.gateway_path
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = var.api_gateway_id
  resource_id   = aws_api_gateway_resource.gateway_resource.id
  http_method   = var.http_method
  authorization = var.authorization
  # authorizer_id = var.authorizer_id
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = var.api_gateway_id
  resource_id             = aws_api_gateway_resource.gateway_resource.id
  http_method             = var.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  # uri                     = var.lambda_uri
}