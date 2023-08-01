resource "aws_api_gateway_rest_api" "ndr_docstore_api" {
  name        = "${terraform.workspace}-DocStoreAPI"
  description = "Document store API for Repo"
}

module "ndr-create-doc-ref" {
  source = "./modules/gateway"

  api_gateway_id = aws_api_gateway_rest_api.ndr_docstore_api.id
  parent_id      = aws_api_gateway_rest_api.ndr_docstore_api.root_resource_id
  http_method    = "POST"
  authorization  = "NONE"
  gateway_path   = "CreateDocumentReference"
  # lambda_uri     = "arn:aws:lambda:eu-west-2:533825906475:function:lambda_handler"
  # authorization  = "CUSTOM"
  # authorizer_id  = aws_api_gateway_authorizer.cis2_authoriser.id

  depends_on = [
    aws_api_gateway_rest_api.ndr_docstore_api
  ]
}


