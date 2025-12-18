#PRMP-892
# moved {
#   from = module.cloudfront-distribution-lg.aws_cloudfront_distribution.distribution[0]
#   to   = aws_cloudfront_distribution.s3_presign_mask
# }

moved {
  from =  module.cloudfront-distribution-lg.aws_cloudfront_distribution.distribution_with_secondary_bucket[0]
  to = aws_cloudfront_distribution.s3_presign_mask
}

moved {
  from = module.cloudfront-distribution-lg.aws_cloudfront_origin_access_control.cloudfront_s3_oac
  to   = aws_cloudfront_origin_access_control.s3
}

moved {
  from = module.cloudfront-distribution-lg.aws_cloudfront_cache_policy.nocache
  to   = aws_cloudfront_cache_policy.nocache
}

moved {
  from = module.cloudfront-distribution-lg.aws_cloudfront_origin_request_policy.viewer_policy
  to   = aws_cloudfront_origin_request_policy.viewer
}