#PRMP-579
# moved {
#   from = aws_cloudfront_distribution.distribution
#   to   = aws_cloudfront_distribution.distribution[0]
# }

moved {
  from = aws_cloudfront_origin_access_control.cloudfront_s3_oac
  to   = aws_cloudfront_origin_access_control.cloudfront_s3_oac
}

moved {
  from = aws_cloudfront_cache_policy.nocache
  to   = aws_cloudfront_cache_policy.nocache
}

moved {
  from = aws_cloudfront_origin_request_policy.viewer_policy
  to   = aws_cloudfront_origin_request_policy.viewer_policy
}