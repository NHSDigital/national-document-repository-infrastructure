resource "aws_route53_record" "dmarc" {
  count   = local.is_shared_workspace ? 1 : 0
  zone_id = module.route53_fargate_ui.zone_id
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  ttl     = 300

  records = ["v=DMARC1; p=none; adkim=s; aspf=s"]
}
