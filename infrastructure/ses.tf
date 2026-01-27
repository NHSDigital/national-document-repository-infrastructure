locals {
  domain_prefix = terraform.workspace == "ndr-test" ? "" : terraform.workspace
  domain        = terraform.workspace == "ndr-test" ? var.domain : "${terraform.workspace}.${var.domain}"
}

module "ndr-feedback-mailbox" {
  source        = "./modules/ses"
  domain_prefix = local.domain_prefix
  domain        = local.domain
  zone_id       = module.route53_fargate_ui.zone_id
  enable        = !local.is_sandbox
}
