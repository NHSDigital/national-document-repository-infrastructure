variable "bucket_domain_name" {
  type        = string
  description = "Domain name to assign CloudFront distribution to"
}

variable "bucket_id" {
  type        = string
  description = "Bucket ID to assign CloudFront distribution to"
}

variable "qualifed_arn" {
  type        = string
  description = "Lambda@Edge function association"
}


output "cloudfront_url" {
  value = aws_cloudfront_distribution.distribution.domain_name
}


output "cloudfront_arn" {
  description = "The ARN of the CloudFront Distribution"
  value       = aws_cloudfront_distribution.distribution.arn
}

output "cloudfront_oai_arn" {
  description = "The ARN of the CloudFront Origin Access Identity (OAI)"
  value       = aws_cloudfront_origin_access_identity.example.arn
}