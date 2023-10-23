resource "aws_cloudwatch_event_rule" "bulk_upload_report_schedule" {
    name = "$(terraform.workspace)_bulk_upload_report_schedule"
    description = "Schedule for Lambda Function"
    schedule_expression = "cron(0/10 * ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_target" "bulk_upload_report_schedule_event" {
    rule = aws_cloudwatch_event_rule.bulk_upload_report_schedule.name
    target_id = "processing_lambda"
    arn = module.bulk-upload-report-lambda.lambda.arn
    depends_on = [ 
        module.bulk-upload-report-lambda,
        aws_cloudwatch_event_rule.bulk_upload_report_schedule
     ]
}


resource "aws_lambda_permission" "bulk_upload_report_schedule_permission" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = module.bulk-upload-report-lambda.lambda.function_name
    principal = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.bulk_upload_report_schedule.arn
    depends_on = [ 
        module.bulk-upload-report-lambda,
        aws_cloudwatch_event_rule.bulk_upload_report_schedule
     ]
}