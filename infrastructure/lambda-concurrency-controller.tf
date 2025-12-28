
data "aws_iam_policy_document" "concurrency_controller_policy" {
  statement {
    effect = "Allow"
    actions = [
      "lambda:PutFunctionConcurrency",
      "lambda:GetFunctionConcurrency"
    ]
    resources = [
      module.bulk-upload-lambda.lambda_arn
    ]
  }
}

module "concurrency-controller-lambda" {
  source  = "./modules/lambda"
  name    = "ConcurrencyController"
  handler = "handlers.concurrency_controller_handler.lambda_handler"

  #This lambda is an orchestrator so should have unlimited conc
  reserved_concurrent_executions = -1

  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false

  iam_role_policy_documents = [
    data.aws_iam_policy_document.concurrency_controller_policy.json
  ]
}

resource "aws_lambda_permission" "office_hours_start_permission" {
  statement_id  = "AllowEventBridgeOfficeHoursStart"
  action        = "lambda:InvokeFunction"
  function_name = module.concurrency-controller-lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.bulk_upload_concurrency_office_hours_start.arn
}

resource "aws_lambda_permission" "office_hours_stop_permission" {
  statement_id  = "AllowEventBridgeOfficeHoursStop"
  action        = "lambda:InvokeFunction"
  function_name = module.concurrency-controller-lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.bulk_upload_concurrency_office_hours_stop.arn
}
