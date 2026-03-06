moved {
  from = module.aws_route53_record.ndr_fargate_record
  to   = module.aws_route53_record.ndr_fargate_record_cname[0]
}
