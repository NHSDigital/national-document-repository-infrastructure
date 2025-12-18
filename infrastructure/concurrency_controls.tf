# Concurrency control schedules 
# Office hour start 
# Original office hours schedule (9 AM daily)
# schedule_expression = "cron(0 9 * * ? *)"
resource "aws_cloudwatch_event_rule" "bulk_upload_concurrency_office_hours_start" {
  name                = "bulk-upload-office-hours-start"
  schedule_expression = "cron(0/2 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "bulk_upload_concurrency_office_hours_start" {
  rule      = aws_cloudwatch_event_rule.bulk_upload_concurrency_office_hours_start.name
  target_id = "office-hours-start"
  arn       = module.concurrency-controller-lambda.lambda_arn

  input = jsonencode({
    targetFunction      = module.bulk-upload-lambda.function_name
    reservedConcurrency = var.office_hours_start_concurrency
  })
}

# Office hours stop 
# Original office hours schedule (5 PM daily)
# schedule_expression = "cron(0 17 * * ? *)"
resource "aws_cloudwatch_event_rule" "bulk_upload_concurrency_office_hours_stop" {
  name                = "bulk-upload-office-hours-stop"
  schedule_expression = "cron(1/2 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "bulk_upload_concurrency_office_hours_stop" {
  rule      = aws_cloudwatch_event_rule.bulk_upload_concurrency_office_hours_stop.name
  target_id = "office-hours-stop"
  arn       = module.concurrency-controller-lambda.lambda_arn

  input = jsonencode({
    targetFunction      = module.bulk-upload-lambda.function_name
    reservedConcurrency = var.office_hours_end_concurrency
  })
}
