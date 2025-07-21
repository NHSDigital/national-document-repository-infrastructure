module "fhir_document_reference_gateway" {
  count               = local.is_production ? 0 : 1
  source              = "./modules/gateway"
  api_gateway_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id           = aws_api_gateway_rest_api.ndr_doc_store_api.root_resource_id
  http_methods        = ["POST", "GET"]
  authorization       = "NONE"
  api_key_required    = true
  gateway_path        = "DocumentReference"
  require_credentials = true
}