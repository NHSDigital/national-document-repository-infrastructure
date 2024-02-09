locals {
  #  prefix = (
  #    local.is_sandbox ? "ndr-dev" :
  #    terraform.workspace
  #  )
  workspace = terraform.workspace
}
module "nrd-app-config" {
  source                  = "./modules/app_config"
  environment             = var.environment
  owner                   = var.owner
  config_environment_name = "repo-config-${local.workspace}"
  config_profile_name     = "repo-config-profile-${local.workspace}"
}