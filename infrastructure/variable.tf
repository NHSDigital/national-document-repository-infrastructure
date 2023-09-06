# Tag Variables
variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

# Bucket Variables
variable "docstore_bucket_name" {
  type    = string
  default = "document-store"
}

variable "zip_store_bucket_name" {
  type    = string
  default = "zip-request-store"
}

variable "lloyd_george_bucket_name" {
  type    = string
  default = "lloyd-george-store"
}

# DynamoDB Table Variables
variable "docstore_dynamodb_table_name" {
  type    = string
  default = "DocumentReferenceMetadata"
}

variable "lloyd_george_dynamodb_table_name" {
  type    = string
  default = "LloydGeorgeReferenceMetadata"
}

variable "zip_store_dynamodb_table_name" {
  type    = string
  default = "ZipStoreReferenceMetadata"
}

# Gateway Variables
variable "cors_require_credentials" {
  type        = bool
  description = "Sets the value of 'Access-Control-Allow-Credentials' which controls whether auth cookies are needed"
  default     = true
}

# VPC Variables
variable "availability_zones" {
  type        = list(string)
  description = "This is a list that specifies all the Availability Zones that will have a pair of public and private subnets"
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "num_public_subnets" {
  type        = number
  description = "Sets the number of public subnets, one per availability zone"
  default     = 3
}

variable "num_private_subnets" {
  type        = number
  description = "Sets the number of private subnets, one per availability zone"
  default     = 3
}

variable "enable_private_routes" {
  type        = bool
  description = "Controls whether the internet gateway can connect to private subnets"
  default     = false
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable DNS  support for VPC"
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames for VPC"
  default     = true
}

variable "domain" {
  type = string
}


# CIS2 Authoriser variables
variable "oidc_providers" {
  type    = list(string)
  default = []
}

variable "cis2_provider_client_id" {
  type    = string
  default = "0000"
}

variable "cis2_provider_client_secret" {
  type    = string
  default = "0000"
}

variable "cis2_provider_oidc_issuer" {
  type    = string
  default = ""
}

variable "NHS_CIS2_ENVIRONMENT" {
  type    = string
  default = ""
}

variable "cis2_provider_authorize_url" {
  type    = string
  default = ""
}

variable "cis2_provider_token_url" {
  type    = string
  default = ""
}

variable "cis2_provider_user_info_url" {
  type    = string
  default = ""
}

variable "cis2_provider_jwks_uri" {
  type    = string
  default = ""
}

variable "cis2_client_callback_urls" {
  type    = list(string)
  default = [""]
}

variable "cis2_client_signout_urls" {
  type    = list(string)
  default = [""]
}
