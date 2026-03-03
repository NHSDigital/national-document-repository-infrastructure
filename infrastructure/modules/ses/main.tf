resource "aws_ses_domain_identity" "ndr_ses" {
  domain = "${terraform.workspace}.${var.domain}"
  count  = var.enable ? 1 : 0
}

resource "aws_ses_domain_dkim" "ndr_dkim" {
  domain = aws_ses_domain_identity.ndr_ses[0].domain

  count      = var.enable ? 1 : 0
  depends_on = [aws_ses_domain_identity.ndr_ses[0]]
}

resource "aws_route53_record" "ndr_ses_dkim_record" {
  zone_id = var.zone_id
  name    = "${aws_ses_domain_dkim.ndr_dkim[0].dkim_tokens[count.index]}._domainkey.${terraform.workspace}"
  type    = "CNAME"
  ttl     = 1800
  records = ["${aws_ses_domain_dkim.ndr_dkim[0].dkim_tokens[count.index]}.dkim.amazonses.com"]

  count      = var.enable ? 3 : 0
  depends_on = [aws_ses_domain_dkim.ndr_dkim[0]]
}

resource "aws_ses_domain_identity_verification" "ndr_ses_domain_verification" {
  domain = aws_ses_domain_identity.ndr_ses[0].domain

  count      = var.enable ? 1 : 0
  depends_on = [aws_route53_record.ndr_ses_dkim_record[0]]
}

resource "aws_ses_domain_mail_from" "reporting" {
  count            = var.enable ? 1 : 0
  domain           = aws_ses_domain_identity.ndr_ses[0].domain
  mail_from_domain = "mail.${aws_ses_domain_identity.ndr_ses[0].domain}"

  behavior_on_mx_failure = "UseDefaultValue"
}

resource "aws_route53_record" "ses_mail_from_mx" {
  count   = var.enable ? 1 : 0
  zone_id = var.zone_id
  name    = "mail.${aws_ses_domain_identity.ndr_ses[0].domain}"
  type    = "MX"
  ttl     = 600

  records = [
    "10 feedback-smtp.eu-west-2.amazonses.com"
  ]
}

resource "aws_route53_record" "ses_mail_from_spf" {
  count   = var.enable ? 1 : 0
  zone_id = var.zone_id
  name    = "mail.${aws_ses_domain_identity.ndr_ses[0].domain}"
  type    = "TXT"
  ttl     = 600

  records = [
    "v=spf1 include:amazonses.com -all"
  ]
}
