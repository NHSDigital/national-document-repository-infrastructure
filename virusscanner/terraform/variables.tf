variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

variable "standalone_vpc_tag" {
  type        = string
  description = "This is the tag assigned to the standalone vpc that should be created manaully before the first run of the infrastructure"
}

variable "standalone_vpc_ig_tag" {
  type        = string
  description = "This is the tag assigned to the standalone vpc ig that should be created as part of the main infrastructure or manually as part of a swap startergy before the first run of the infrastructure"
}

variable "cloud_security_email_param_environment" {
  type        = string
  description = "This is the environement reference in cloud security email param store key"
}

variable "black_hole_address" {
  type        = string
  default     = "198.51.100.0/24"
  description = "using reserved address that does not lead anywhere to make sure CloudStorageSecurity console is not available"
}

variable "public_address" {
  type        = string
  default     = "0.0.0.0/0"
  description = "using public address to make sure CloudStorageSecurity console is available"
}