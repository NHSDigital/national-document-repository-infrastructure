locals {
  #  domain = (
  #    local.is_production ? var.certificate_domain :
  #    local.is_sandbox ? "ndr-dev.${var.domain}" :
  #    "${terraform.workspace}.${var.domain}"
  #  )
  domain_prefix = (
    local.is_production ? var.environment :
    local.is_sandbox ? "ndr-dev" :
    terraform.workspace
  )
  domain = "${terraform.workspace}.${var.domain}"
}

module "ndr-feedback-mailbox" {
  source           = "./modules/ses"
  domain           = local.domain
  zone_id          = module.route53_fargate_ui.zone_id
  from_mail_prefix = "mailing"
  enable           = true
  #enable           = !local.is_sandbox
}