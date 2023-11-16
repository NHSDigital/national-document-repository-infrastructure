module "route53_fargate_ui" {
  source                = "./modules/route53"
  environment           = var.environment
  owner                 = var.owner
  domain                = var.domain
  certificate_domain    = var.certificate_domain
  using_arf_hosted_zone = true
  dns_name              = module.ndr-ecs-fargate.dns_name

  api_gateway_subdomain_name   = local.api_gateway_subdomain_name
  api_gateway_full_domain_name = aws_api_gateway_domain_name.custom_api_domain.regional_domain_name
  api_gateway_zone_id          = aws_api_gateway_domain_name.custom_api_domain.regional_zone_id
}
