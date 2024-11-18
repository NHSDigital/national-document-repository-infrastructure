resource "aws_lambda_function" "lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename                       = data.archive_file.lambda.output_path
  function_name                  = "${terraform.workspace}_${var.name}"
  role                           = aws_iam_role.lambda_execution_role.arn
  handler                        = var.handler
  source_code_hash               = data.archive_file.lambda.output_base64sha256
  runtime                        = "python3.11"
  timeout                        = var.lambda_timeout
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  ephemeral_storage {
    size = var.lambda_ephemeral_storage
  }
  environment {
    variables = var.lambda_environment_variables
  }
  layers = [
    "arn:aws:lambda:eu-west-2:580247275435:layer:LambdaInsightsExtension:38",
    "arn:aws:lambda:eu-west-2:282860088358:layer:AWS-AppConfig-Extension:81"
  ]
}

resource "aws_api_gateway_integration" "lambda_integration" {
  for_each                = var.is_gateway_integration_needed ? { for idx, method in var.http_methods : idx => method } : {}
  rest_api_id             = var.rest_api_id
  resource_id             = var.resource_id
  http_method             = each.value
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

resource "aws_lambda_permission" "lambda_permission" {
  count         = var.is_invoked_from_gateway ? 1 : 0
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "apigateway.amazonaws.com"
  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${var.api_execution_arn}/*/*"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "${terraform.workspace}_lambda_execution_role_${var.name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# resource "aws_iam_role_policy_attachment" "lambda_execution_policy" {
#   count      = length(var.iam_role_policy_documents)
#   role       = aws_iam_role.lambda_execution_role.name
#   policy_arn = var.iam_role_policy_documents[count.index]
# }

# data "aws_iam_policy_document" "combined_policies" {
#   source_policy_documents = var.iam_role_policy_documents  # Combine all provided policy documents
# }


resource "aws_iam_policy" "lambda_combined_policy" {
  name   = "${terraform.workspace}_lambda_combined_policy_${var.name}"
  policy = data.aws_iam_policy_document.combined_policies.json
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_combined_policy.arn
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "placeholder_lambda.py"
  output_path = "placeholder_lambda_payload.zip"
}

# data "aws_iam_policy_document" "combined_policies" {
#   source_policy_documents = [
#     data.s3_read_policy_document,
#     data.s3_write_policy_document,
#     data.sqs_read_policy_document,
#     data.sqs_write_policy_document,
#     data.dynamodb_read_policy_document,
#     data.dynamodb_write_policy_document
#   ]
# }