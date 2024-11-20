output "dynamodb_policy" {
  value = aws_iam_policy.dynamodb_policy.arn
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.ndr_dynamodb_table.arn
}

output "dynamodb_stream_arn" {
  value = aws_dynamodb_table.ndr_dynamodb_table.stream_arn
}

output "table_name" {
  value = aws_dynamodb_table.ndr_dynamodb_table.id
}