resource "aws_api_gateway_rest_api" "ndr_docstore_api" {
  name        = "${terraform.workspace}-DocStoreAPI"
  description = "Document store API for Repo"
}

module "ndr-create-doc-ref" {
  source = "./modules/gateway"

  api_gateway_id = aws_api_gateway_rest_api.ndr_docstore_api.id
  parent_id      = aws_api_gateway_rest_api.ndr_docstore_api.root_resource_id
  http_method    = "POST"
  authorization  = "NONE" // "CUSTOM"
  gateway_path   = "CreateDocumentReference"
  lambda_uri     = null
  authorizer_id  = null

  depends_on = [
    aws_api_gateway_rest_api.ndr_docstore_api
  ]
}


