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

resource "aws_api_gateway_domain_name" "custom_api_domain" {
  domain_name              = local.api_gateway_full_domain_name
  regional_certificate_arn = module.ndr-ecs-fargate-app.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "api_mapping" {
  api_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  stage_name  = var.environment
  domain_name = local.api_gateway_full_domain_name

  depends_on = [aws_api_gateway_deployment.ndr_api_deploy, aws_api_gateway_rest_api.ndr_doc_store_api]
}

resource "aws_api_gateway_resource" "auth_resource" {
  rest_api_id = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id   = aws_api_gateway_rest_api.ndr_doc_store_api.root_resource_id
  path_part   = "Auth"
}

# API Config
resource "aws_api_gateway_deployment" "ndr_api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.ndr_doc_store_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.ndr_doc_store_api.body,
      module.authoriser-lambda,
      module.back-channel-logout-gateway,
      module.back_channel_logout_lambda,
      module.create-doc-ref-gateway,
      module.create-doc-ref-lambda,
      module.create-token-gateway,
      module.create-token-lambda,
      module.delete-doc-ref-gateway,
      module.delete-doc-ref-lambda,
      module.document-manifest-job-gateway,
      module.document-manifest-job-lambda,
      module.feature-flags-gateway,
      module.feature-flags-lambda,
      module.lloyd-george-stitch-gateway,
      module.lloyd-george-stitch-lambda,
      module.logout-gateway,
      module.logout_lambda,
      module.search-document-references-gateway,
      module.search-document-references-lambda,
      module.search-patient-details-gateway,
      module.search-patient-details-lambda,
      module.send-feedback-gateway,
      module.send-feedback-lambda,
      module.update-upload-state-gateway,
      module.update-upload-state-lambda,
      module.upload_confirm_result_gateway,
      module.upload_confirm_result_lambda,
      module.virus_scan_result_gateway,
      module.virus_scan_result_lambda
    ]))
  }

  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
    aws_api_gateway_stage.ndr_api,
    module.authoriser-lambda,
    module.back-channel-logout-gateway,
    module.back_channel_logout_lambda,
    module.create-doc-ref-gateway,
    module.create-doc-ref-lambda,
    module.create-token-gateway,
    module.create-token-lambda,
    module.delete-doc-ref-gateway,
    module.delete-doc-ref-lambda,
    module.document-manifest-job-gateway,
    module.document-manifest-job-lambda,
    module.feature-flags-gateway,
    module.feature-flags-lambda,
    module.lloyd-george-stitch-gateway,
    module.lloyd-george-stitch-lambda,
    module.logout-gateway,
    module.logout_lambda,
    module.search-document-references-gateway,
    module.search-document-references-lambda,
    module.search-patient-details-gateway,
    module.search-patient-details-lambda,
    module.send-feedback-gateway,
    module.send-feedback-lambda,
    module.update-upload-state-gateway,
    module.update-upload-state-lambda,
    module.upload_confirm_result_gateway,
    module.upload_confirm_result_lambda,
    module.virus_scan_result_gateway,
    module.virus_scan_result_lambda,
    module.get-doc-nrl-lambda
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "ndr_api" {
  deployment_id = aws_api_gateway_deployment.ndr_api_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.ndr_doc_store_api.id
  stage_name    = var.environment
}



resource "aws_api_gateway_gateway_response" "unauthorised_response" {
  rest_api_id   = aws_api_gateway_rest_api.ndr_doc_store_api.id
  response_type = "DEFAULT_4XX"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"      = contains(["prod"], terraform.workspace) ? "'https://${var.domain}'" : "'https://${terraform.workspace}.${var.domain}'"
    "gatewayresponse.header.Access-Control-Allow-Methods"     = "'*'"
    "gatewayresponse.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Auth,X-Api-Key,X-Amz-Security-Token,X-Auth-Cookie,Accept'"
    "gatewayresponse.header.Access-Control-Allow-Credentials" = "'true'"
  }
}

resource "aws_api_gateway_gateway_response" "bad_gateway_response" {
  rest_api_id   = aws_api_gateway_rest_api.ndr_doc_store_api.id
  response_type = "DEFAULT_5XX"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"      = contains(["prod"], terraform.workspace) ? "'https://${var.domain}'" : "'https://${terraform.workspace}.${var.domain}'"
    "gatewayresponse.header.Access-Control-Allow-Methods"     = "'*'"
    "gatewayresponse.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Auth,X-Api-Key,X-Amz-Security-Token,X-Auth-Cookie,Accept'"
    "gatewayresponse.header.Access-Control-Allow-Credentials" = "'true'"
  }
}

module "api_endpoint_url_ssm_parameter" {
  source              = "./modules/ssm_parameter"
  name                = "api_endpoint"
  description         = "api endpoint url for ${var.environment}"
  resource_depends_on = aws_api_gateway_deployment.ndr_api_deploy
  value               = aws_api_gateway_deployment.ndr_api_deploy.invoke_url
  type                = "SecureString"
  owner               = var.owner
  environment         = var.environment
}
