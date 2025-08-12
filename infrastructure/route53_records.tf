# A record for API Gateway Custom Domain Name
resource "aws_route53_record" "pdm_api" {
  name    = aws_api_gateway_domain_name.mtls_custom_api_domain.domain_name
  type    = "A"
  zone_id = module.route53_mtls_api.zone_id

  alias {
    name                   = aws_api_gateway_domain_name.mtls_custom_api_domain.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.mtls_custom_api_domain.regional_zone_id
    evaluate_target_health = true
  }
}