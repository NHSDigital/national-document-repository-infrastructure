module "route53_fargate_ui" {
  source                = "./modules/route53"
  environment           = var.environment
  owner                 = var.owner
  domain                = var.domain
  using_arf_hosted_zone = true
  dns_name              = module.ndr-ecs-fargate-app.dns_name

  api_gateway_subdomain_name   = local.api_gateway_subdomain_name
  api_gateway_full_domain_name = aws_api_gateway_domain_name.custom_api_domain.regional_domain_name
  api_gateway_zone_id          = aws_api_gateway_domain_name.custom_api_domain.regional_zone_id

  api_cloudfront_subdomain_name = local.cloudfront_subdomain_name
  cloudfront_domain_name        = aws_cloudfront_distribution.s3_presign_mask.domain_name
  cloudfront_zone_id            = "Z2FDTNDATAQYW2"
}

resource "aws_route53_record" "ndr_mtls_api_record" {
  name    = aws_api_gateway_domain_name.custom_api_domain_mtls.domain_name
  type    = "A"
  zone_id = module.route53_fargate_ui.zone_id

  alias {
    name                   = aws_api_gateway_domain_name.custom_api_domain_mtls.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.custom_api_domain_mtls.regional_zone_id
    evaluate_target_health = true
  }
}