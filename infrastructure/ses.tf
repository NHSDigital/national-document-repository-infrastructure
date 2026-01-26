# locals {
#   feedback_domain_prefix = "ndr-dev"
#   feedback_domain        = "${local.feedback_domain_prefix}.${var.domain}"
# }
#
# module "ndr-feedback-mailbox" {
#   source        = "./modules/ses"
#   domain_prefix = local.feedback_domain_prefix
#   domain        = local.feedback_domain
#   zone_id       = module.route53_fargate_ui.zone_id
#
#   enable = local.is_shared_infra_workspace
# }
