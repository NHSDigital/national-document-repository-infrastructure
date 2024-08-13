variable "bucket_domain_name" {
  type        = string
  description = "Domain name to assign CloudFront distribution to"
}

variable "bucket_id" {
  type        = string
  description = "Bucket ID to assign CloudFront distribution to"
}

output "cloudfront_arn" {
  value = aws_cloudfront_distribution.distribution.arn
}