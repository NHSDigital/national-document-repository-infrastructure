# A set of resources that do not belong to one workspace but are shared across the environment.

module "ssm_param_mtls_common_names" {
  source               = "./modules/ssm_parameter"
  environment          = var.environment
  owner                = var.owner
  name                 = "mtls_common_names"
  type                 = "SecureString"
  description          = "A list of mtls common names that will be used to determine authorisation and resources used."
  value                = "REPLACE_ME"
  key_id               = module.pdm_encryption_key.id
  ignore_value_changes = true
}
