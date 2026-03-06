moved {
  from = resource.aws_route53_record.ndr_fargate_record
  to   = resource.aws_route53_record.ndr_fargate_record_cname[0]
}
