resource "aws_ses_domain_identity" "ndr_ses" {
  domain = "${terraform.workspace}.${var.domain}"
  count  = var.enable ? 1 : 0
}

resource "aws_ses_domain_dkim" "ndr_dkim" {
  domain = aws_ses_domain_identity.ndr_ses[0].domain
  count  = var.enable ? 1 : 0
}

resource "aws_route53_record" "ndr_ses_dkim_record" {
  count   = var.enable ? 3 : 0
  zone_id = var.zone_id
  name    = "${aws_ses_domain_dkim.ndr_dkim[0].dkim_tokens[count.index]}._domainkey"
  type    = "CNAME"
  ttl     = 600
  records = ["${aws_ses_domain_dkim.ndr_dkim[0].dkim_tokens[count.index]}.dkim.amazonses.com"]
}

# resource "aws_ses_domain_identity_verification" "ndr_ses_domain_verification" {
#   domain = aws_ses_domain_identity.ndr_ses[0].domain
#   count  = var.enable ? 1 : 0

#   depends_on = [aws_route53_record.ndr_ses_dkim_record[0]]
# }

resource "aws_route53_record" "ndr_amazonses_verification_record" {
  count   = var.enable ? 1 : 0
  zone_id = var.zone_id
  name    = aws_ses_domain_mail_from.ndr_mail_from[0].mail_from_domain
  type    = "TXT"
  ttl     = 600
  records = ["v=spf1 include:amazonses.com -all"]
}

resource "aws_ses_domain_mail_from" "ndr_mail_from" {
  count            = var.enable ? 1 : 0
  domain           = aws_ses_domain_identity.ndr_ses[0].domain
  mail_from_domain = "mailing.${aws_ses_domain_identity.ndr_ses[0].domain}"
}

resource "aws_route53_record" "ndr_mx_record" {
  count   = var.enable ? 1 : 0
  name    = aws_ses_domain_mail_from.ndr_mail_from[0].mail_from_domain
  type    = "MX"
  records = ["10 feedback-smtp.eu-west-2.amazonses.com"]
  zone_id = var.zone_id
  ttl     = 300
}
