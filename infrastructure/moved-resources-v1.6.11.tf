moved {
  from = resource.aws_route53_record.validation
  to   = resource.aws_route53_record.mtls_cert_validation
}
