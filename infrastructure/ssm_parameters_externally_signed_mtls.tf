# Creating Params to hold a copy of externally signed client certs and keys
module "ssm_param_external_client_cert" {
  count                = local.is_sandbox ? 0 : 1
  source               = "./modules/ssm_parameter"
  environment          = var.environment
  owner                = var.owner
  name                 = "external_client_cert"
  type                 = "SecureString"
  description          = "Externally signed client certificate for mTLS"
  value                = "REPLACE_ME"
  key_id               = module.pdm_encryption_key.id
  ignore_value_changes = true
}

module "ssm_param_external_client_key" {
  count                = local.is_sandbox ? 0 : 1
  source               = "./modules/ssm_parameter"
  environment          = var.environment
  owner                = var.owner
  name                 = "external_client_key"
  type                 = "SecureString"
  description          = "Externally signed client certificate for mTLS"
  value                = "REPLACE_ME"
  key_id               = module.pdm_encryption_key.id
  ignore_value_changes = true
}

module "ssm_param_foobar_client_cert" {
  count                = local.is_sandbox ? 0 : 1
  source               = "./modules/ssm_parameter"
  environment          = var.environment
  owner                = var.owner
  name                 = "foobar_client_cert"
  type                 = "SecureString"
  description          = "Externally signed foobar client certificate for test purposes"
  value                = "REPLACE_ME"
  key_id               = module.pdm_encryption_key.id
  ignore_value_changes = true
}

module "ssm_param_foobar_client_key_" {
  count                = local.is_sandbox ? 0 : 1
  source               = "./modules/ssm_parameter"
  environment          = var.environment
  owner                = var.owner
  name                 = "foobar_client_key"
  type                 = "SecureString"
  description          = "Externally signed foobar client certificate for test purposes"
  value                = "REPLACE_ME"
  key_id               = module.pdm_encryption_key.id
  ignore_value_changes = true
}