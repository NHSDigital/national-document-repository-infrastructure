# Availability Zone variables
variable "azs" {
  type        = list(string)
  description = "This is a list that specifies all the Availability Zones that will have public and private subnets in it. Defaulting this value to an empty list selects of all the Availability Zones in the region you specify when defining the provider in your terraform project."
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

# CIDR Defintions
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