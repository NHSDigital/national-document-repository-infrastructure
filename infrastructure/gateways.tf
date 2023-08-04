resource "aws_api_gateway_rest_api" "ndr_docstore_api" {
  name        = "${terraform.workspace}-DocStoreAPI"
  description = "Document store API for Repo"

  tags = {
    Name        = "${terraform.workspace}-docstore-api"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

module "create-doc-ref-gateway" {
  source = "./modules/gateway"

  api_gateway_id           = aws_api_gateway_rest_api.ndr_docstore_api.id
  parent_id                = aws_api_gateway_rest_api.ndr_docstore_api.root_resource_id
  http_method              = "POST"
  authorization            = "NONE" // "CUSTOM"
  gateway_path             = "DocumentReference"
  authorizer_id            = null
  cors_require_credentials = var.cors_require_credentials
  docstore_bucket_name     = var.docstore_bucket_name
  api_execution_arn        = aws_api_gateway_rest_api.ndr_docstore_api.execution_arn
  owner                    = var.owner
  environment              = var.environment

  depends_on = [
    aws_api_gateway_rest_api.ndr_docstore_api,
  ]
}

resource "aws_api_gateway_deployment" "ndr_api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.ndr_docstore_api.id
  stage_name  = var.environment

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.ndr_docstore_api,
      module.create-doc-ref-gateway,
    ]))
  }

  depends_on = [
    aws_api_gateway_rest_api.ndr_docstore_api,
    module.create-doc-ref-gateway,
  ]
}

resource "aws_api_gateway_gateway_response" "unauthorised_response" {
  rest_api_id   = aws_api_gateway_rest_api.ndr_docstore_api.id
  response_type = "DEFAULT_4XX"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"      = terraform.workspace != "prod" ? "'https://${terraform.workspace}.access-request-fulfilment.patient-deductions.nhs.uk'" : "'https://access-request-fulfilment.patient-deductions.nhs.uk'"
    "gatewayresponse.header.Access-Control-Allow-Methods"     = "'*'"
    "gatewayresponse.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Auth-Cookie,Accept'"
    "gatewayresponse.header.Access-Control-Allow-Credentials" = var.cors_require_credentials ? "'true'" : "'false'"
  }
}

resource "aws_api_gateway_gateway_response" "bad_gateway_response" {
  rest_api_id   = aws_api_gateway_rest_api.ndr_docstore_api.id
  response_type = "DEFAULT_5XX"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"      = terraform.workspace != "prod" ? "'https://${terraform.workspace}.access-request-fulfilment.patient-deductions.nhs.uk'" : "'https://access-request-fulfilment.patient-deductions.nhs.uk'"
    "gatewayresponse.header.Access-Control-Allow-Methods"     = "'*'"
    "gatewayresponse.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Auth-Cookie,Accept'"
    "gatewayresponse.header.Access-Control-Allow-Credentials" = var.cors_require_credentials ? "'true'" : "'false'"
  }
}