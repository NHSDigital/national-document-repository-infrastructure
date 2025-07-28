variable "environment" {
  description = "Environment name used for tagging and resource naming."
  type        = string
}

variable "owner" {
  description = "Name of the owner used for tagging."
  type        = string
}

variable "cloudfront_acl" {
  description = "Set to true if this WAF ACL is for a CloudFront distribution."
  type        = bool
}

variable "api" {
  description = "True if using the firewall for an api - removes AWSBotControl."
  type        = bool
<<<<<<< HEAD
=======
  description = "True if using the firewall for an api - removes AWSBotControl and SizeRestrictions_BODY"
>>>>>>> 0ec9ad0 ([NDR-182] exclude body rule)
  default     = false
}

