locals {
  domain_prefix = terraform.workspace
  domain        = "${local.domain_prefix}.${var.domain}"
}
