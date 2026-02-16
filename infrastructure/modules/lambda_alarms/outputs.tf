output "error_alarm_name" {
  value = aws_cloudwatch_metric_alarm.lambda_error.alarm_name
}

output "duration_alarm_name" {
  value = aws_cloudwatch_metric_alarm.lambda_duration_alarm.alarm_name
}

output "memory_alarm_name" {
  value = aws_cloudwatch_metric_alarm.lambda_memory_alarm.alarm_name
}
