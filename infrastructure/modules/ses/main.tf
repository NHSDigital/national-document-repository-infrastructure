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

resource "aws_ses_domain_identity_verification" "ndr_ses_domain_verification" {
  domain = aws_ses_domain_identity.ndr_ses[0].domain
  count  = var.enable ? 1 : 0

  depends_on = [aws_route53_record.ndr_ses_dkim_record[0]]
}
