variable "current_account_id" {
  type = string
}

variable "kms_key_name" {
  type = string
}

variable "kms_key_description" {
  type = string
}

variable "kms_key_rotation_enabled" {
  type    = bool
  default = true
}