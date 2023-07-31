resource "aws_api_gateway_rest_api" "ndr_api" {
  name        = "${terraform.workspace}-api-gateway"
  description = "Proxy to handle requests to our API"
}

resource "aws_api_gateway_resource" "ndr_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.ndr_api.id
  parent_id   = aws_api_gateway_rest_api.ndr_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.ndr_api.id
  resource_id   = aws_api_gateway_resource.ndr_api_resource.id
  http_method   = "ANY"
  authorization = "NONE"
  # authorization  = "CUSTOM"
  # authorizer_id  = aws_api_gateway_authorizer.cis2_authoriser.id
  request_parameters = {
    "method.request.path.proxy" = true
  }
}
# resource "aws_api_gateway_integration" "lambda_integration" {
#   rest_api_id   = aws_api_gateway_rest_api.ndr_api.id
#   resource_id   = aws_api_gateway_resource.ndr_api_resource.id
#   http_method = ws_api_gateway_method.proxy_method.http_method
#   integration_http_method = "ANY"
#   type                    = "AWS_PROXY"
#   uri                     = "http://your.domain.com/{proxy}"

#   request_parameters =  {
#     "integration.request.path.proxy" = "method.request.path.proxy"
#   }
# }

# output "http_method" {
#   value = var.http_method
# }
