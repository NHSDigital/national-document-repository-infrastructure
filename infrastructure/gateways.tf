module "ndr-docstore-api" {
  source = "./modules/api-gateway/api"

  gateway_name = "${terraform.workspace}-DocStoreAPI"
  gateway_desc = "Document store API for Repo"
}

module "ndr-create-doc-ref" {
  source         = "./modules/api-gateway/gateway"

  api_gateway_id = ndr_api_id
  resource_id    = aws_api_gateway_resource.doc_ref_collection_resource.id
  http_method    = "POST"
  authorization = "NONE"
  # lambda_arn     = aws_lambda_function.create_doc_ref_lambda.invoke_arn
  # authorization  = "CUSTOM"
  # authorizer_id  = aws_api_gateway_authorizer.cis2_authoriser.id

   depends_on = [
    module.ndr-docstore-api
 ]
}


