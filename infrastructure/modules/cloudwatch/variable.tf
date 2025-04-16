variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

variable "log_group_name" {
  description = "Name of the Cloudwatch log group"
  type        = string
}

variable "retention_in_days" {
  description = "Days to retain log group messages (Indefinite by default)"
  type        = number
  default     = 0
}

variable "log_group_encryption_key" {
  description = "The ARN of an AWS-managed customer master key (CMK) to encrypt logs"
  type        = string
  default     = null
}
