module "lambda-layer-core" {
  source     = "./modules/lambda_layers"
  account_id = data.aws_caller_identity.current.account_id
  layer_name = "core"
}

module "lambda-layer-data" {
  source     = "./modules/lambda_layers"
  account_id = data.aws_caller_identity.current.account_id
  layer_name = "data"
}