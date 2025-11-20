#PRMP-579
moved {
  from = aws_cloudfront_distribution.distribution
  to   = aws_cloudfront_distribution.distribution[0]
}