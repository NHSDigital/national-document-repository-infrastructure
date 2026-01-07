resource "aws_ses_domain_identity" "reporting" {
  domain = var.domain
}

resource "aws_route53_record" "ses_domain_verification" {
  zone_id = module.route53_fargate_ui.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = 600
  records = [aws_ses_domain_identity.reporting.verification_token]
}

resource "aws_ses_domain_identity_verification" "reporting" {
  domain     = aws_ses_domain_identity.reporting.domain
  depends_on = [aws_route53_record.ses_domain_verification]
}

resource "aws_ses_domain_dkim" "reporting" {
  domain = aws_ses_domain_identity.reporting.domain
}

resource "aws_route53_record" "ses_dkim_records" {
  count   = 3
  zone_id = module.route53_fargate_ui.zone_id
  name    = "${element(aws_ses_domain_dkim.reporting.dkim_tokens, count.index)}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = 600
  records = ["${element(aws_ses_domain_dkim.reporting.dkim_tokens, count.index)}.dkim.amazonses.com"]
}
