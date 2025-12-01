#PRMP-579
moved {
  from = aws_cloudfront_distribution.distribution[0]
  to   = aws_cloudfront_distribution.distribution
}

moved {
  from = module.cloudfront-distribution-lg.cloudfront_s3_oac
  to   = aws_cloudfront_origin_access_control.cloudfront_s3_oac
}

moved {
  from = module.cloudfront-distribution-lg.nocache
  to   = aws_cloudfront_cache_policy.nocache
}

moved {
  from = module.cloudfront-distribution-lg.viewer_policy
  to   = aws_cloudfront_origin_request_policy.viewer_policy
}