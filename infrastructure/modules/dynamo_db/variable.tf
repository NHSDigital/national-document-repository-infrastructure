variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = null
}

variable "attributes" {
  description = "List of nested attribute definitions"
  type        = list(map(string))
  default     = []
}

variable "hash_key" {
  type    = string
  default = null
}

variable "sort_key" {
  type    = string
  default = null
}

variable "billing_mode" {
  type    = string
  default = "PAY_PER_REQUEST"
}

variable "ttl_enabled" {
  type    = bool
  default = false
}

variable "ttl_attribute_name" {
  type    = string
  default = ""
}

variable "global_secondary_indexes" {
  type    = any
  default = []
}

variable "deletion_protection_enabled" {
  type    = bool
  default = null
}

variable "stream_enabled" {
  type    = bool
  default = false
}

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

variable "point_in_time_recovery_enabled" {
  type    = bool
  default = false
}

output "dynamodb_policy" {
  value = aws_iam_policy.dynamodb_policy.arn
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.ndr_dynamodb_table.arn
}