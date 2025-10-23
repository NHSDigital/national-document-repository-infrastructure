output "cloudfront_url" {
  value = aws_cloudfront_distribution.distribution[0].domain_name
}

output "cloudfront_arn" {
  description = "The ARN of the CloudFront Distribution"
  value       = aws_cloudfront_distribution.distribution[0].arn
}