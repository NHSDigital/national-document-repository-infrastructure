variable "domain" {
  description = "The root domain name to be registered with SES and used for verification."
  type        = string
}

variable "zone_id" {
  description = "The Route53 hosted zone ID where DNS verification records will be created."
  type        = string
}

variable "is_sandbox" {
  description = "Whether the workspace being created is a sandbox."
  type        = bool
}
