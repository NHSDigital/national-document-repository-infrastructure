resource "aws_lambda_function" "lambda_resource" {
  handler          = var.handler
  function_name    = var.function
  runtime          = "java11"
  role             = aws_iam_role.lambda_execution_role.arn
  timeout          = 15
  memory_size      = 448
  filename         = var.create_doc_ref_lambda_jar_filename
  source_code_hash = filebase64sha256(var.create_doc_ref_lambda_jar_filename)
  layers = [
    "arn:aws:lambda:eu-west-2:580247275435:layer:LambdaInsightsExtension:21",
    aws_lambda_layer_version.document_store_lambda_layer.arn
  ]
  environment {
    variables = merge({
      AMPLIFY_BASE_URL                = local.amplify_base_url
      TEST_DOCUMENT_STORE_BUCKET_NAME = aws_s3_bucket.test_document_store.bucket
      VIRUS_SCANNER_IS_STUBBED        = var.workspace_is_a_sandbox ? "true" : var.virus_scanner_is_stubbed
    }, local.common_environment_variables)
  }
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_doc_ref_lambda.arn
  principal     = "apigateway.amazonaws.com"
  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.lambda_api.execution_arn}/*/*"
}

locals {
  create_document_reference_invocation_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.lambda_api.id}/${var.api_gateway_stage}/${module.create_doc_ref_endpoint.http_method}${aws_api_gateway_resource.doc_ref_collection_resource.path}"
}
