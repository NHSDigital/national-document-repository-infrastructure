module "get-doc-nrl-gateway" {
  # Gateway Variables
  source              = "./modules/gateway"
  api_gateway_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id           = aws_api_gateway_rest_api.ndr_doc_store_api.root_resource_id
  http_methods        = ["GET"]
  authorization       = "NONE"
  gateway_path        = "GetDocument"
  require_credentials = false
  origin              = contains(["prod"], terraform.workspace) ? "'https://${var.domain}'" : "'https://${terraform.workspace}.${var.domain}'"
  api_key_required    = true
  # Lambda Variables
  api_execution_arn = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  owner             = var.owner
  environment       = var.environment

  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
  ]
}

resource "aws_api_gateway_usage_plan" "apim" {
  name = "${terraform.workspace}_apim_usage_plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.ndr_doc_store_api.id
    stage  = aws_api_gateway_stage.ndr_api.stage_name
  }
}

resource "aws_api_gateway_api_key" "apim" {
  name = "${terraform.workspace}_apim_api_key"
}

resource "aws_api_gateway_usage_plan_key" "apim" {
  key_id        = aws_api_gateway_api_key.apim.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.apim.id
}