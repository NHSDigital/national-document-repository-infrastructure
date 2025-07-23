variable "name" {
  description = "Unique name for the Lambda function."
  type        = string

  validation {
    condition     = length(var.name) < 34
    error_message = "The lambda name cannot be longer than 33 characters as this breaks the IAM role name limit"
  }
}

variable "handler" {
  description = "Function entry point in the codebase (e.g., 'index.handler')."
  type        = string
}

variable "lambda_environment_variables" {
  description = "Map of environment variables to set in the Lambda function."
  type        = map(string)
  default     = {}
}

variable "rest_api_id" {
  description = "ID of the associated API Gateway REST API."
  type        = string
}

variable "resource_id" {
  description = "ID of the API Gateway resource (path) to attach Lambda to."
  type        = string
  default     = ""
}

variable "is_gateway_integration_needed" {
  description = "Indicate whether the lambda need an aws_api_gateway_integration resource block"
  type        = bool
  default     = true
}

variable "is_invoked_from_gateway" {
  description = "Indicate whether the lambda is supposed to be invoked by API gateway. Should be true for authoriser lambda."
  type        = bool
  default     = true
}

variable "http_methods" {
  description = "List of HTTP methods to integrate with the Lambda function."
  type        = list(string)
  default     = []
}

variable "api_execution_arn" {
  description = "Execution ARN of the API Gateway used for granting invoke permissions."
  type        = string
}

variable "iam_role_policy_documents" {
  description = "List of IAM policy document ARNs to attach to the Lambda execution role."
  type        = list(string)
  default     = []
}

variable "lambda_timeout" {
  description = "Function timeout in seconds."
  type        = number
  default     = 30
}

variable "lambda_ephemeral_storage" {
  description = "Amount of ephemeral storage (in MB) to allocate to the Lambda function."
  type        = number
  default     = 512
}

variable "memory_size" {
  description = "Amount of memory to allocate to the Lambda function (in MB)."
  type        = number
  default     = 512
}

variable "reserved_concurrent_executions" {
  type        = number
  description = "The number of concurrent execution allowed for lambda. A value of 0 will stop lambda from running, and -1 removes any concurrency limitations. Default to -1."
  default     = -1
}

variable "default_policies" {
  default = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
  ]
}

