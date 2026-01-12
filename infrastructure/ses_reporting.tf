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

resource "aws_route53_record" "ses_dkim" {
  count   = 3
  zone_id = module.route53_fargate_ui.zone_id
  name    = "${element(aws_ses_domain_dkim.reporting.dkim_tokens, count.index)}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = 600
  records = ["${element(aws_ses_domain_dkim.reporting.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_ses_domain_mail_from" "reporting" {
  domain           = aws_ses_domain_identity.reporting.domain
  mail_from_domain = "mail.${var.domain}"

  behavior_on_mx_failure = "UseDefaultValue"
}

resource "aws_route53_record" "ses_mail_from_mx" {
  zone_id = module.route53_fargate_ui.zone_id
  name    = "mail.${var.domain}"
  type    = "MX"
  ttl     = 600

  records = [
    "10 feedback-smtp.eu-west-2.amazonses.com"
  ]
}

resource "aws_route53_record" "ses_mail_from_spf" {
  zone_id = module.route53_fargate_ui.zone_id
  name    = "mail.${var.domain}"
  type    = "TXT"
  ttl     = 600

  records = [
    "v=spf1 include:amazonses.com -all"
  ]
}

resource "aws_route53_record" "spf_root" {
  zone_id = module.route53_fargate_ui.zone_id
  name    = var.domain
  type    = "TXT"
  ttl     = 300

  records = [
    "v=spf1 include:amazonses.com -all"
  ]
}