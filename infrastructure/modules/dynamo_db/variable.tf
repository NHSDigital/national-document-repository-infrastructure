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
  type        = string
  description = "Primary partition key for the table"
  default     = null
}

variable "sort_key" {
  type        = string
  description = "Optional sort key for composite primary key"
  default     = null
}

variable "billing_mode" {
  type        = string
  description = "DynamoDB billing mode (e.g., PAY_PER_REQUEST)"
  default     = "PAY_PER_REQUEST"
}

variable "ttl_enabled" {
  type        = bool
  description = "Whether to enable TTL (Time to Live) on items"
  default     = false
}

variable "ttl_attribute_name" {
  type        = string
  description = "Name of the TTL attribute."
  default     = ""
}

variable "global_secondary_indexes" {
  type        = any
  description = "List of optional Global Secondary Indexes"
  default     = []
}

variable "deletion_protection_enabled" {
  type        = bool
  description = "Prevents table from accidental deletion."
  default     = null
}

variable "stream_enabled" {
  type        = bool
  description = "Whether DynamoDB Streams are enabled."
  default     = false
}

variable "stream_view_type" {
  type        = string
  description = "Type of stream view (e.g., OLD_IMAGE)."
  default     = "NEW_AND_OLD_IMAGES"
}

variable "environment" {
  type        = string
  description = "Deployment environment tag used for naming and labeling (e.g., dev, prod)"
}

variable "owner" {
  type        = string
  description = "Identifies the team or person responsible for the resource (used for tagging)"
}

variable "point_in_time_recovery_enabled" {
  type        = bool
  description = "Enables PITR for backups"
  default     = false
}
