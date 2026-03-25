module "healthcare_worker_api_base_url" {
  count                = local.is_sandbox ? 0 : 1
  source               = "./modules/ssm_parameter"
  environment          = var.environment
  owner                = var.owner
  name                 = "hcw_api_url"
  type                 = "String"
  description          = "Base url for Healthcare Worker API endpoints"
  value                = "REPLACE ME"
  ignore_value_changes = true
}

data "aws_ssm_parameter" "healthcare_worker_api_base_url" {
  name = "/ndr/${var.shared_infra_workspace}/hcw_api_url"
}
