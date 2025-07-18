module "toggle-bulk-upload-lambda" {
  source         = "./modules/lambda"
  name           = "ToggleBulkUploadLambda"
  handler        = "handlers.toggle_bulk_upload_handler.lambda_handler"
  lambda_timeout = 60
  memory_size    = 128

  # iam_role_policy_documents = [
  #   aws_iam_policy.lambda_toggle_bulk_upload_policy.arn
  # ]
  iam_role_policy_documents = [
    data.aws_iam_policy_document.lambda_toggle_bulk_upload_document.json
  ]

  lambda_environment_variables = {
    ESM_UUID = aws_lambda_event_source_mapping.bulk_upload_esm.uuid
  }

  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false
}

