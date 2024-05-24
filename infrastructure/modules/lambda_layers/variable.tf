variable "account_id" {
  type = string
}

variable "layer_zip_file_name" {
  type = string
  default = "placeholder_lambda_payload.zip"
}

variable "layer_name" {
  type = string
}

# Outputs
output "lambda_layer_arn" {
  value = aws_lambda_layer_version.lambda_layer.arn
}

output "lambda_layer_policy_arn" {
  value = aws_iam_policy.lambda_layer_policy.arn
}

