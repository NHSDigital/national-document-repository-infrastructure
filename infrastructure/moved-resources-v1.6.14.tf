moved {
  from = module.route53_fargate_ui.aws_route53_record.ndr_fargate_record
  to   = module.route53_fargate_ui.aws_route53_record.ndr_fargate_record_cname[0]
}
