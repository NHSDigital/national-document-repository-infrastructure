moved {
  from = resource.aws_route53_record.validation
  to   = resource.aws_route53_record.mtls_cert_validation
}

moved {
  from = aws_cloudfront_origin_request_policy.viewer
  to   = aws_cloudfront_origin_request_policy.viewer[0]
}

moved {
  from = aws_cloudfront_origin_request_policy.uploader
  to   = aws_cloudfront_origin_request_policy.uploader[0]
}

moved {
  from = aws_cloudfront_cache_policy.nocache
  to   = aws_cloudfront_cache_policy.nocache[0]
}