module "create-doc-ref-lambda" {
  source = "./modules/lambda"

  handler  = "uk.nhs.digital.docstore.lambdas.CreateDocumentReferenceHandler::handleRequest"
  function = "${terraform.workspace}_CreateDocumentReferenceHandler"
  depends_on = [
    aws_api_gateway_rest_api.ndr_docstore_api
  ]
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "${terraform.workspace}_LambdaExecution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_insights_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}