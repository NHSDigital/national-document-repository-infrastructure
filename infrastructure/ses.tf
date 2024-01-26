module "ndr-feedback-mailbox" {
  source  = "./modules/ses"
  domain  = var.domain
  zone_id = module.route53_fargate_ui.zone_id
  enable  = !local.is_sandbox
}