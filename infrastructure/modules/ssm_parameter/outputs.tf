output "ssm_ignore_change_value" {
  value       = aws_ssm_parameter.secret_ignore_value_changes[0].value # The actual value to be outputted
  description = "The value of ssm parameter"
}
