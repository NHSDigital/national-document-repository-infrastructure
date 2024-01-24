module "ndr-feedback-mailbox" {
  source           = "./modules/ses"
  domain           = var.domain
  zone_id          = module.route53_fargate_ui.zone_id
  from_mail_prefix = "mailing"
  enable           = local.is_sandbox_or_test
}