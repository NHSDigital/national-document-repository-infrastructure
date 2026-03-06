module "route53_fargate_ui" {
  source                       = "./modules/route53"
  domain                       = var.domain
  using_arf_hosted_zone        = true
  dns_name                     = module.ndr-ecs-fargate-app.dns_name
  dns_zone_id                  = module.ndr-ecs-fargate-app.dns_zone_id
  api_gateway_subdomain_name   = local.api_gateway_subdomain_name
  api_gateway_full_domain_name = aws_api_gateway_domain_name.custom_api_domain.regional_domain_name
  api_gateway_zone_id          = aws_api_gateway_domain_name.custom_api_domain.regional_zone_id
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

resource "aws_route53_record" "ndr_cloudfront_alias" {
  name    = local.cloudfront_full_domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.ndr.zone_id

  alias {
    name                   = aws_cloudfront_distribution.s3_presign_mask.domain_name
    zone_id                = aws_cloudfront_distribution.s3_presign_mask.hosted_zone_id
    evaluate_target_health = false
  }
}

data "aws_route53_zone" "ndr" {
  name = var.domain
}
