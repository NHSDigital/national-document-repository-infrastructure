output "ssm_value" {
  value       = var.ignore_value_changes ? aws_ssm_parameter.secret_ignore_value_changes[0].value : aws_ssm_parameter.secret[0].value
  description = "The value of ssm parameter"
}
