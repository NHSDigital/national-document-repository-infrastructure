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

variable "web_acl_id" {
  type        = string
  description = "Web ACL to associate this Cloudfront distribution with"
}

