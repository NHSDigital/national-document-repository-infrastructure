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

  api_gateway_id = aws_api_gateway_rest_api.ndr_docstore_api.id
  parent_id      = aws_api_gateway_rest_api.ndr_docstore_api.root_resource_id
  http_method    = "POST"
  authorization  = "NONE" // "CUSTOM"
  gateway_path   = "CreateDocumentReference"
  lambda_uri     = null
  authorizer_id  = null

  owner       = var.owner
  environment = var.environment

  depends_on = [
    aws_api_gateway_rest_api.ndr_docstore_api
  ]
}

resource "aws_api_gateway_deployment" "ndr_api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.ndr_docstore_api.id
  stage_name  = var.api_gateway_stage

  triggers = {
    redeployment = sha1(jsonencode([
      module.create-doc-ref-gateway,
    ]))

    tags = {
      Name        = "${terraform.workspace}-api-deployment"
      Owner       = var.owner
      Environment = var.environment
      Workspace   = terraform.workspace
    }
  }
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
  tags = {
    Name        = "${terraform.workspace}-api-unauthorised"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

resource "aws_api_gateway_gateway_response" "bad_gateway_response" {
  rest_api_id   = aws_api_gateway_rest_api.ndr_docstore_api.id
  response_type = "DEFAULT_5XX"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"      = var.cors_origin
    "gatewayresponse.header.Access-Control-Allow-Methods"     = "'*'"
    "gatewayresponse.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Auth-Cookie,Accept'"
    "gatewayresponse.header.Access-Control-Allow-Credentials" = var.cors_credentials
  }

  tags = {
    Name        = "${terraform.workspace}-api-bad-gateway"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}