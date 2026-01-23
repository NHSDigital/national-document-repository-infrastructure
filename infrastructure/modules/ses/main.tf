resource "aws_ses_domain_identity" "ndr_ses" {
  count  = var.enable ? 1 : 0
  domain = var.domain
}

# SES domain identity verification TXT record (required)
resource "aws_route53_record" "ndr_ses_verification_record" {
  count   = var.enable ? 1 : 0
  zone_id = var.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = 600

  records = [aws_ses_domain_identity.ndr_ses[0].verification_token]

  depends_on = [aws_ses_domain_identity.ndr_ses[0]]
}

resource "aws_ses_domain_identity_verification" "ndr_ses_domain_verification" {
  count  = var.enable ? 1 : 0
  domain = aws_ses_domain_identity.ndr_ses[0].domain

  depends_on = [aws_route53_record.ndr_ses_verification_record[0]]
}

resource "aws_ses_domain_dkim" "ndr_dkim" {
  count  = var.enable ? 1 : 0
  domain = aws_ses_domain_identity.ndr_ses[0].domain

  depends_on = [aws_ses_domain_identity.ndr_ses[0]]
}

resource "aws_route53_record" "ndr_ses_dkim_record" {
  count   = var.enable ? 3 : 0
  zone_id = var.zone_id

  name    = "${aws_ses_domain_dkim.ndr_dkim[0].dkim_tokens[count.index]}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = 1800
  records = ["${aws_ses_domain_dkim.ndr_dkim[0].dkim_tokens[count.index]}.dkim.amazonses.com"]

  depends_on = [aws_ses_domain_dkim.ndr_dkim[0]]
}
