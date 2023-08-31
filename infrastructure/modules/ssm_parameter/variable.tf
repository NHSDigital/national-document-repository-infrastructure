variable "name" {
  description = "Name of SSM parameter"
  type        = string
  default     = null
}

variable "value" {
  description = "Value of the parameter"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the parameter"
  type        = string
  default     = null
}

variable "type" {
  description = "Valid types are String, StringList and SecureString."
  type        = string
  default     = "SecureString"
}

variable "resource_depends_on" {
  default = ""
}

# Tags
variable "environment" {
  type = string
}

variable "owner" {
  type = string
}
