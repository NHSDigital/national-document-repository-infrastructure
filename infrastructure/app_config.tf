locals {
  #  prefix = (
  #    local.is_sandbox ? "ndr-dev" :
  #    terraform.workspace
  #  )
  workspace = terraform.workspace
}
module "ndr-app-config" {
  source                  = "./modules/app_config"
  environment             = var.environment
  owner                   = var.owner
  config_environment_name = local.workspace
  config_profile_name     = "config-profile-${local.workspace}"
}