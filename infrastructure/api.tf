# Create Document Store API
resource "aws_api_gateway_rest_api" "ndr_doc_store_api" {
  name        = "${terraform.workspace}-DocStoreAPI"
  description = "Document store API for Repo"

  tags = {
    Name        = "${terraform.workspace}-docstore-api"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

# API Config
resource "aws_api_gateway_deployment" "ndr_api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.ndr_doc_store_api.id
  stage_name  = var.environment

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.ndr_doc_store_api.body,
      module.create-doc-ref-gateway,
    ]))
  }

  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
    module.create-doc-ref-gateway,
    module.create-doc-ref-lambda
  ]
}


resource "aws_api_gateway_gateway_response" "unauthorised_response" {
  rest_api_id   = aws_api_gateway_rest_api.ndr_doc_store_api.id
  response_type = "DEFAULT_4XX"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"      = "'https://${terraform.workspace}.${var.domain}'"
    "gatewayresponse.header.Access-Control-Allow-Methods"     = "'*'"
    "gatewayresponse.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Auth-Cookie,Accept'"
    "gatewayresponse.header.Access-Control-Allow-Credentials" = var.cors_require_credentials ? "'true'" : "'false'"
  }
}

resource "aws_api_gateway_gateway_response" "bad_gateway_response" {
  rest_api_id   = aws_api_gateway_rest_api.ndr_doc_store_api.id
  response_type = "DEFAULT_5XX"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"      = "'https://${terraform.workspace}.${var.domain}'"
    "gatewayresponse.header.Access-Control-Allow-Methods"     = "'*'"
    "gatewayresponse.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Auth-Cookie,Accept'"
    "gatewayresponse.header.Access-Control-Allow-Credentials" = var.cors_require_credentials ? "'true'" : "'false'"
  }
}
