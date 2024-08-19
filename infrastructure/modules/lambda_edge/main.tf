terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.11"
    }
  }
}

resource "aws_lambda_function" "lambda" {
  provider = aws # Alternative AWS provider for Lambda@Edge region

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
  publish = true # Publish the version for Lambda@Edge
}


data "archive_file" "lambda" {
  type        = "zip"
  source_file = "placeholder_lambda.py"
  output_path = "placeholder_lambda_payload.zip"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "lambda_execution_role" {
  name               = "${terraform.workspace}_lambda_execution_role_${var.name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy" {
  count      = length(var.iam_role_policies)
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = var.iam_role_policies[count.index]
}