

#Availability zones for Amazon region
variable "availability_zones" {
  type        = list(string)
  description = "This is a list that specifies all the Availability Zones that will have a pair of public and private subnets"
}

# Toggles
variable "enable_dns_support" {
  type        = bool
  description = "This allows AWS DNS support to be switched on or off."
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "This allows AWS DNS hostname support to be switched on or off."
  default     = true
}

variable "enable_private_routes" {
  type    = bool
  default = false
}

# CIDR Definitions
variable "ig_cidr" {
  type        = string
  description = "This specifies the CIDR block for the internet gateway."
  default     = "0.0.0.0/0"
}

variable "ig_ipv6_cidr" {
  type        = string
  description = "This specifies the IPV6 CIDR block for the internet gateway."
  default     = "::/0"
}

variable "vpc_cidr" {
  type        = string
  description = "This specifices the VPC CIDR block"
  default     = "10.0.0.0/16"
}

# Tags

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

variable "num_public_subnets" {
  type = number
}

variable "num_private_subnets" {
  type = number
}