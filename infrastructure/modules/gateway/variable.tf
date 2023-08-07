variable "api_gateway_id" {
  type = string
}
variable "parent_id" {
  type = string
}
variable "gateway_path" {
  type = string
}
variable "http_method" {
  type = string
}
variable "authorization" {
  type = string
}
variable "authorizer_id" {
  type = string
}
variable "owner" {
  type = string
}
variable "environment" {
  type = string
}

variable "cors_require_credentials" {
  type = bool
}

variable "docstore_bucket_name" {
  type = string
}

variable "api_execution_arn" {
  type = string
}

output "gateway_resource_id" {
  value = aws_api_gateway_resource.gateway_resource.id
}