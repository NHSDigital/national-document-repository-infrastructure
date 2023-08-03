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
variable "lambda_uri" {
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

variable "methods" {
  type = string
}