# Concurrency control schedules
# These times are set to ensure 9 AM - 7 PM UK local time is always covered regardless of GMT/BST:
# - During GMT (winter): 8 AM UTC = 8 AM local, 7 PM UTC = 7 PM local (covers 9 AM - 7 PM with buffer)
# - During BST (summer): 8 AM UTC = 9 AM local, 7 PM UTC = 8 PM local (covers 9 AM - 7 PM with buffer)
# This guarantees the core working hours (9 AM - 7 PM UK time) always have reduced concurrency.

# Office hours start (8 AM UTC)
resource "aws_cloudwatch_event_rule" "bulk_upload_concurrency_office_hours_start" {
  name                = "bulk-upload-office-hours-start"
  schedule_expression = "cron(0 8 * * ? *)"
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

# Office hours stop (7 PM UTC / 19:00 UTC)
resource "aws_cloudwatch_event_rule" "bulk_upload_concurrency_office_hours_stop" {
  name                = "bulk-upload-office-hours-stop"
  schedule_expression = "cron(0 19 * * ? *)"
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
