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

# Concurrency control triggers 
# Concurrency freeze during ECS deploy 
resource "aws_cloudwatch_event_rule" "bulk_upload_concurrency_deploy" {
  name = "bulk-upload-concurrency-deploy"
  event_pattern = jsonencode({
    source      = ["deploy.pipeline"]
    detail-type = ["freeze-concurrency"]
  })
}

resource "aws_cloudwatch_event_target" "bulk_upload_concurrency_deploy" {
  rule      = aws_cloudwatch_event_rule.bulk_upload_concurrency_deploy.name
  target_id = "freeze-concurrency"
  arn       = module.concurrency-controller-lambda.lambda_arn

  input = jsonencode({
    targetFunction      = module.bulk-upload-lambda.function_name
    reservedConcurrency = 0
  })
}

# Restore concurrency after release
resource "aws_cloudwatch_event_rule" "bulk_upload_concurrency_release_restore" {
  name = "bulk-upload-concurrency-release-restore"
  event_pattern = jsonencode({
    source      = ["release.pipeline"]
    detail-type = ["restore-bulk-upload-concurrency"]
  })
}

resource "aws_cloudwatch_event_target" "bulk_upload_concurrency_release_restore" {
  rule      = aws_cloudwatch_event_rule.bulk_upload_concurrency_release_restore.name
  target_id = "restore-bulk-upload-concurrency"
  arn       = module.concurrency-controller-lambda.lambda_arn

  input = jsonencode({
    targetFunction      = module.bulk-upload-lambda.function_name
    reservedConcurrency = local.bulk_upload_lambda_concurrent_limit
  })
}
