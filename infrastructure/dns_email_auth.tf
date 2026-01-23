resource "aws_route53_record" "dmarc" {
  zone_id = module.route53_fargate_ui.zone_id
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  ttl     = 300

  records = ["v=DMARC1; p=none; adkim=s; aspf=s"]
  #   if we add rua=mailto:very_cool_email@${var.domain} we will receive reports in that email
}
