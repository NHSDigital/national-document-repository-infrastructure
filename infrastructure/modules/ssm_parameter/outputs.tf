output "value" {
  value       = aws_ssm_parameter.secret.value
  description = "Value of SSM parameter"
}