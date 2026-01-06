output "invoke_arn" {
  value = local.lambda.invoke_arn
}

output "qualified_arn" {
  value = local.lambda.qualified_arn
}

output "function_name" {
  value = local.lambda.function_name
}

output "timeout" {
  value = local.lambda.timeout
}

output "lambda_arn" {
  value = local.lambda.arn
}

output "lambda_execution_role_name" {
  value = aws_iam_role.lambda_execution_role.name
}

output "lambda_execution_role_arn" {
  value = aws_iam_role.lambda_execution_role.arn
}
