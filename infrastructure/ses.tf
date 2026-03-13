module "ses" {
  source     = "./modules/ses"
  domain     = var.domain
  zone_id    = module.route53_fargate_ui.zone_id
  is_sandbox = local.is_sandbox
}
