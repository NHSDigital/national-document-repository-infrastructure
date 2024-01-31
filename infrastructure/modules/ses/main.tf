resource "aws_ses_domain_identity" "ndr_ses" {
  domain = var.domain
  count  = var.enable ? 1 : 0
}

resource "aws_ses_domain_dkim" "ndr_dkim" {
  domain = aws_ses_domain_identity.ndr_ses[0].domain

  count      = var.enable ? 1 : 0
  depends_on = [aws_ses_domain_identity.ndr_ses[0]]
}

resource "aws_route53_record" "ndr_ses_dkim_record" {
  zone_id = var.zone_id
  name    = "${aws_ses_domain_dkim.ndr_dkim[0].dkim_tokens[count.index]}._domainkey.${var.domain_prefix}"
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
