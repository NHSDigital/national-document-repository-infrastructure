variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

variable "num_public_subnets" {
  type    = number
  default = 3
}

variable "num_private_subnets" {
  type    = number
  default = 3
}

variable "cors_require_credentials" {
  type = bool
}