resource "aws_route53_zone" "ndr_zone" {
  count = var.using_arf_hosted_zone ? 0 : 1
  name  = var.domain
  tags = {
    Name = "${terraform.workspace}-ndr_zone"
  }
}

data "aws_route53_zone" "ndr_zone" {
  name  = var.domain
  count = var.using_arf_hosted_zone ? 1 : 0
}

resource "aws_route53_record" "ndr_fargate_record" {
  count   = var.create_fargate_record ? 1 : 0
  name    = terraform.workspace
  type    = "CNAME"
  records = [var.dns_name]
  zone_id = local.zone_id
  ttl     = 300
}

resource "aws_route53_record" "ndr_gateway_api_record" {
  count = var.create_gateway_api_record ? 1 : 0
  name    = var.api_gateway_subdomain_name
  type    = "A"
  zone_id = local.zone_id

  alias {
    name                   = var.api_gateway_full_domain_name
    zone_id                = var.api_gateway_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "ndr_mtls_gateway_api_record" {
  count   = var.create_mtls_gateway_api_record ? 1 : 0
  name    = var.api_gateway_subdomain_name
  type    = "A"
  zone_id = local.zone_id

  alias {
    name                   = var.api_gateway_subdomain_name
    zone_id                = var.api_gateway_zone_id
    evaluate_target_health = true
  }
}