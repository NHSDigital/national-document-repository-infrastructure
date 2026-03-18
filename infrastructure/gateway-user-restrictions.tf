module "user_restrictions_gateway" {
  source              = "./modules/gateway"
  api_gateway_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id           = aws_api_gateway_rest_api.ndr_doc_store_api.root_resource_id
  http_methods        = ["GET", "POST"]
  authorization       = "CUSTOM"
  gateway_path        = "UserRestriction"
  authorizer_id       = aws_api_gateway_authorizer.repo_authoriser.id
  require_credentials = true
  origin              = local.base_url_with_quotes
}

module "user_restriction_id_gateway" {
  source              = "./modules/gateway"
  api_gateway_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id           = module.user_restrictions_gateway.gateway_resource_id
  http_methods        = ["PATCH"]
  gateway_path        = "{id}"
  authorization       = "CUSTOM"
  authorizer_id       = aws_api_gateway_authorizer.repo_authoriser.id
  require_credentials = true
  origin              = local.base_url_with_quotes

  request_parameters = {
    "method.request.path.id" = true
  }
}

module "user_restrictions_user_search_gateway" {
  source              = "./modules/gateway"
  api_gateway_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id           = module.user_restrictions_gateway.gateway_resource_id
  http_methods        = ["GET"]
  gateway_path        = "SearchUser"
  authorization       = "CUSTOM"
  authorizer_id       = aws_api_gateway_authorizer.repo_authoriser.id
  require_credentials = true
  origin              = local.base_url_with_quotes
}
