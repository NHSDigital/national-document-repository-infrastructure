module "fhir_document_reference_gateway" {
  count               = 1
  source              = "./modules/gateway"
  api_gateway_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id           = aws_api_gateway_rest_api.ndr_doc_store_api.root_resource_id
  http_methods        = ["POST", "GET", "DELETE"]
  authorization       = "NONE"
  api_key_required    = true
  gateway_path        = "FhirDocumentReference"
  require_credentials = true
}

module "document_reference_gateway" {
  source              = "./modules/gateway"
  api_gateway_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id           = aws_api_gateway_rest_api.ndr_doc_store_api.root_resource_id
  http_methods        = ["POST"]
  authorization       = "CUSTOM"
  gateway_path        = "DocumentReference"
  authorizer_id       = aws_api_gateway_authorizer.repo_authoriser.id
  require_credentials = true
  origin              = local.base_url_with_quotes
}

module "document_reference_id_gateway" {
  source              = "./modules/gateway"
  api_gateway_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id           = module.document_reference_gateway.gateway_resource_id
  http_methods        = ["PUT", "GET"]
  authorization       = "CUSTOM"
  gateway_path        = "{id}"
  authorizer_id       = aws_api_gateway_authorizer.repo_authoriser.id
  require_credentials = true
  origin              = local.base_url_with_quotes

  request_parameters = {
    "method.request.path.id" = true
  }

  depends_on = [module.document_reference_gateway]
}
