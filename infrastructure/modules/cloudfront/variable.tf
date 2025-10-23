variable "bucket_domain_name" {
  description = "Domain name to assign CloudFront distribution to."
  type        = string
}

variable "bucket_id" {
  description = "Bucket ID to assign CloudFront distribution to."
  type        = string
}

variable "qualifed_arn" {
  description = "Lambda@Edge function association."
  type        = string
}

variable "web_acl_id" {
  description = "Web ACL to associate this CloudFront distribution with."
  type        = string
  default     = ""
}

variable "has_secondary_bucket" {
  description = "Whether distribution is associated with a secondary buckets"
  type        = bool
}

variable "secondary_bucket_id" {
  description = "Secondary bucket IDs"
  type        = string
}

variable "secondary_bucket_domain_name" {
  description = "Secondary bucket domain names"
  type        = string
}

variable "secondary_bucket_path_pattern" {
  description = "Path patter for secondary bucket"
  type        = string
}
