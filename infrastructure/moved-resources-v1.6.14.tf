moved {
  from = aws_route53_record.ndr_fargate_record
  to   = aws_route53_record.ndr_fargate_record_cname[0]
}
