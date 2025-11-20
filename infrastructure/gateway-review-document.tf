module "review-document-gateway" {
  source              = "./modules/gateway"
  api_gateway_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id           = aws_api_gateway_rest_api.ndr_doc_store_api.root_resource_id
  http_methods        = ["GET"]
  authorization       = "CUSTOM"
  gateway_path        = "DocumentReview"
  authorizer_id       = aws_api_gateway_authorizer.repo_authoriser.id
  require_credentials = true
  origin              = contains(["prod"], terraform.workspace) ? "'https://${var.domain}'" : "'https://${terraform.workspace}.${var.domain}'"
}

resource "aws_api_gateway_resource" "review-document-id" {
  rest_api_id = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id   = module.review-document-gateway.gateway_resource_id
  path_part   = "{id}"
}

module "review-document-version-gateway" {
  source              = "./modules/gateway"
  api_gateway_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id           = aws_api_gateway_resource.review-document-id.id
  http_methods        = ["GET", "PATCH"]
  authorization       = "CUSTOM"
  gateway_path        = "{version}"
  authorizer_id       = aws_api_gateway_authorizer.repo_authoriser.id
  require_credentials = true
  origin              = contains(["prod"], terraform.workspace) ? "'https://${var.domain}'" : "'https://${terraform.workspace}.${var.domain}'"

  request_parameters = {
    "method.request.path.id"      = true
    "method.request.path.version" = true
  }
}

module "review-document-status-gateway" {
  source              = "./modules/gateway"
  api_gateway_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id           = module.review-document-version-gateway.gateway_resource_id
  gateway_path        = "Status"
  http_methods        = ["GET"]
  require_credentials = true
  authorization       = "CUSTOM"
  authorizer_id       = aws_api_gateway_authorizer.repo_authoriser.id
  origin              = contains(["prod"], terraform.workspace) ? "'https://${var.domain}'" : "'https://${terraform.workspace}.${var.domain}'"
}


