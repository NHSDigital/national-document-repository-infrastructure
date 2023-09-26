variable "name" {
  type = string
}

variable "handler" {
  type = string
}

variable "lambda_environment_variables" {
  type    = map(string)
  default = {}
}

variable "rest_api_id" {
  type = string
}

variable "resource_id" {
  type = string
}

variable "http_method" {
  type = string
}

variable "api_execution_arn" {
  type = string
}

variable "iam_role_policies" {
  type = list(string)
}

variable "lambda_timeout" {
  type    = number
  default = 30
}

variable "lambda_ephemeral_storage" {
  type    = number
  default = 512
}
