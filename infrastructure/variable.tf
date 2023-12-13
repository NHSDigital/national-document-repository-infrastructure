# Tag Variables
variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

variable "certificate_subdomain_name_prefix" {
  type        = string
  description = "Prefix to add to subdomains on certification configurations, dev envs use api-{env}, prod envs use api.{env}"
  default     = "api-"
}

# Bucket Variables
variable "docstore_bucket_name" {
  type        = string
  description = "The name of S3 bucket to store ARF documents"
  default     = "document-store"
}

variable "zip_store_bucket_name" {
  type    = string
  default = "zip-request-store"
}

variable "staging_store_bucket_name" {
  type    = string
  default = "staging-bulk-store"
}

variable "lloyd_george_bucket_name" {
  type        = string
  description = "The name of S3 bucket to store Lloyd George documents"
  default     = "lloyd-george-store"
}

# DynamoDB Table Variables
variable "docstore_dynamodb_table_name" {
  type        = string
  description = "The name of dynamodb table to store the metadata of ARF documents"
  default     = "DocumentReferenceMetadata"
}

variable "lloyd_george_dynamodb_table_name" {
  type        = string
  description = "The name of dynamodb table to store the metadata of Lloyd George documents"
  default     = "LloydGeorgeReferenceMetadata"
}

variable "zip_store_dynamodb_table_name" {
  type    = string
  default = "ZipStoreReferenceMetadata"
}

variable "auth_state_dynamodb_table_name" {
  type        = string
  description = "The name of dynamodb table to store the state values (for CIS2 authorisation)"
  default     = "AuthStateReferenceMetadata"
}

variable "auth_session_dynamodb_table_name" {
  type        = string
  description = "The name of dynamodb table to store user login sessions"
  default     = "AuthSessionReferenceMetadata"
}

variable "bulk_upload_report_dynamodb_table_name" {
  type        = string
  description = "The name of dynamodb table to store bulk upload status"
  default     = "BulkUploadReport"
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

variable "certificate_domain" {
  type = string
}

variable "cloud_only_service_instances" {
  type    = number
  default = 1
}

variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "mesh_url" {
  type        = string
  description = "URL of MESH service"
}

variable "mesh_mailbox_ssm_param_name" {
  type        = string
  description = "Name of SSM parameter containing MESH mailbox name"
}

variable "mesh_password_ssm_param_name" {
  type        = string
  description = "Name of SSM parameter containing MESH mailbox password"
}

variable "mesh_shared_key_ssm_param_name" {
  type        = string
  description = "Name of SSM parameter containing MESH shared key"
}

variable "mesh_client_cert_ssm_param_name" {
  type        = string
  description = "Name of SSM parameter containing MESH client certificate"
}

variable "mesh_client_key_ssm_param_name" {
  type        = string
  description = "Name of SSM parameter containing MESH client key"
}

variable "mesh_ca_cert_ssm_param_name" {
  type        = string
  description = "Name of SSM parameter containing MESH CA certificate"
}

variable "disable_message_header_validation" {
  type        = string
  description = "if true then relaxes the restrictions on MESH message headers"
  default     = false
}

variable "message_destination" {
  default = ""
}

variable "cloudwatch_alarm_evaluation_periods" {}

variable "poll_frequency" {}

locals {
  is_sandbox       = contains(["ndra", "ndrb", "ndrc", "ndrd"], terraform.workspace)
  is_production    = contains(["pre-prod", "prod"], terraform.workspace)
  is_force_destroy = contains(["ndra", "ndrb", "ndrc", "ndrd", "ndr-test"], terraform.workspace)

  bulk_upload_lambda_concurrent_limit = 5

  api_gateway_subdomain_name   = "${var.certificate_subdomain_name_prefix}${terraform.workspace}"
  api_gateway_full_domain_name = "${var.certificate_subdomain_name_prefix}${terraform.workspace}.${var.domain}"
  account_id                   = data.aws_caller_identity.current.account_id
  mesh_ecs_environment_variables = [
    { name : "MESH_URL", value : var.mesh_url },
    { name : "MESH_MAILBOX_SSM_PARAM_NAME", value : var.mesh_mailbox_ssm_param_name },
    { name : "MESH_PASSWORD_SSM_PARAM_NAME", value : var.mesh_password_ssm_param_name },
    { name : "MESH_SHARED_KEY_SSM_PARAM_NAME", value : var.mesh_shared_key_ssm_param_name },
    { name : "MESH_CLIENT_CERT_SSM_PARAM_NAME", value : var.mesh_client_cert_ssm_param_name },
    { name : "MESH_CLIENT_KEY_SSM_PARAM_NAME", value : var.mesh_client_key_ssm_param_name },
    { name : "MESH_CA_CERT_SSM_PARAM_NAME", value : var.mesh_ca_cert_ssm_param_name },
    { name : "SNS_TOPIC_ARN", value : "aws_sns_topic.nems_events.arn" },
    { name : "MESSAGE_DESTINATION", value : "var.message_destination" },
    { name : "DISABLE_MESSAGE_HEADER_VALIDATION", value : false },
    { name : "POLL_FREQUENCY", value : var.poll_frequency }
  ]
}