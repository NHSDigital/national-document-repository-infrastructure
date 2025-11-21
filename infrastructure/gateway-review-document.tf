module "review_document_gateway" {
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

resource "aws_api_gateway_resource" "review_document_id" {
  rest_api_id = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id   = module.review_document_gateway.gateway_resource_id
  path_part   = "{id}"
}

module "review_document_version_gateway" {
  source              = "./modules/gateway"
  api_gateway_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id           = aws_api_gateway_resource.review_document_id.id
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
