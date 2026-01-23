resource "aws_acm_certificate" "mtls_api_gateway_cert" {
  domain_name       = local.mtls_api_gateway_full_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Record used by ACM for DNS Validation
resource "aws_route53_record" "mtl_validation" {
  for_each = {
    for dvo in aws_acm_certificate.mtls_api_gateway_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = module.route53_fargate_ui.zone_id
}

resource "aws_acm_certificate_validation" "mtls_api_gateway_cert" {
  certificate_arn         = aws_acm_certificate.mtls_api_gateway_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.mtl_validation : record.fqdn]
}

resource "aws_acm_certificate" "cloudfront_cert" {
  provider          = aws.us_east_1
  domain_name       = local.cloudfront_full_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cloudfront_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cloudfront_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = module.route53_fargate_ui.zone_id
}

resource "aws_acm_certificate_validation" "cloudfront_cert" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cloudfront_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cloudfront_cert_validation : record.fqdn]
}
