resource "aws_ses_domain_identity" "ndr_ses" {
  domain = var.is_sandbox ? "${terraform.workspace}.dev.${var.domain}" : "${terraform.workspace}.${var.domain}"
}

resource "aws_ses_domain_dkim" "ndr_dkim" {
  domain = aws_ses_domain_identity.ndr_ses.domain

  depends_on = [aws_ses_domain_identity.ndr_ses]
}

resource "aws_route53_record" "ndr_ses_dkim_record" {
  count = 3

  zone_id = var.zone_id
  name    = var.is_sandbox ? "${aws_ses_domain_dkim.ndr_dkim.dkim_tokens[count.index]}._domainkey.${terraform.workspace}.dev" : "${aws_ses_domain_dkim.ndr_dkim.dkim_tokens[count.index]}._domainkey.${terraform.workspace}"
  type    = "CNAME"
  ttl     = 1800
  records = ["${aws_ses_domain_dkim.ndr_dkim.dkim_tokens[count.index]}.dkim.amazonses.com"]

  depends_on = [aws_ses_domain_dkim.ndr_dkim]
}

resource "aws_ses_domain_identity_verification" "ndr_ses_domain_verification" {
  domain = aws_ses_domain_identity.ndr_ses.domain

  depends_on = [aws_route53_record.ndr_ses_dkim_record]
}

resource "aws_ses_domain_mail_from" "reporting" {
  domain           = aws_ses_domain_identity.ndr_ses.domain
  mail_from_domain = "mail.${aws_ses_domain_identity.ndr_ses.domain}"

  behavior_on_mx_failure = "UseDefaultValue"
}

resource "aws_route53_record" "ses_mail_from_mx" {
  zone_id = var.zone_id
  name    = "mail.${aws_ses_domain_identity.ndr_ses.domain}"
  type    = "MX"
  ttl     = 600

  records = [
    "10 feedback-smtp.eu-west-2.amazonses.com"
  ]
}

resource "aws_route53_record" "ses_mail_from_spf" {
  zone_id = var.zone_id
  name    = "mail.${aws_ses_domain_identity.ndr_ses.domain}"
  type    = "TXT"
  ttl     = 600

  records = [
    "v=spf1 include:amazonses.com -all"
  ]
}

resource "aws_route53_record" "dmarc" {
  zone_id = var.zone_id
  name    = "_dmarc.${aws_ses_domain_identity.ndr_ses.domain}"
  type    = "TXT"
  ttl     = 300

  records = ["v=DMARC1; p=none; adkim=s; aspf=s"]
}
