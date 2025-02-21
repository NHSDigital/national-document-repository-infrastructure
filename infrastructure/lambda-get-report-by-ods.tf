module "get-report-by-ods-gateway" {
  # Gateway Variables
  source              = "./modules/gateway"
  api_gateway_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id           = aws_api_gateway_rest_api.ndr_doc_store_api.root_resource_id
  http_methods        = ["GET"]
  authorization       = "CUSTOM"
  gateway_path        = "OdsReport"
  authorizer_id       = aws_api_gateway_authorizer.repo_authoriser.id
  require_credentials = true
  origin              = contains(["prod"], terraform.workspace) ? "'https://${var.domain}'" : "'https://${terraform.workspace}.${var.domain}'"

  # Lambda Variables
  api_execution_arn = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  owner             = var.owner
  environment       = var.environment

  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
  ]
}

module "get-report-by-ods-alarm" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.get-report-by-ods-lambda.function_name
  lambda_timeout       = module.get-report-by-ods-lambda.timeout
  lambda_name          = "get_report_by_ods_handler"
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.get-report-by-ods-alarm-topic.arn]
  ok_actions           = [module.get-report-by-ods-alarm-topic.arn]
  depends_on           = [module.get-report-by-ods-lambda, module.get-report-by-ods-alarm-topic]
}


module "get-report-by-ods-alarm-topic" {
  source                = "./modules/sns"
  sns_encryption_key_id = module.sns_encryption_key.id
  current_account_id    = data.aws_caller_identity.current.account_id
  topic_name            = "get-report-by-ods-alarm-topic"
  topic_protocol        = "lambda"
  topic_endpoint        = module.get-report-by-ods-lambda.lambda_arn
  depends_on            = [module.sns_encryption_key]
  delivery_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudwatch.amazonaws.com"
        },
        "Action" : [
          "SNS:Publish",
        ],
        "Condition" : {
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:cloudwatch:eu-west-2:${data.aws_caller_identity.current.account_id}:alarm:*"
          }
        }
        "Resource" : "*"
      }
    ]
  })
}

module "get-report-by-ods-lambda" {
  source  = "./modules/lambda"
  name    = "GetReportsByODSLambda"
  handler = "handlers.get_report_by_ods_handler.lambda_handler"
  iam_role_policy_documents = [
    aws_iam_policy.ssm_access_policy.policy,
    module.statistical-reports-store.s3_write_policy_document,
    module.lloyd_george_reference_dynamodb_table.dynamodb_read_policy_document,
  ]
  rest_api_id  = aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id  = module.get-report-by-ods-gateway.gateway_resource_id
  http_methods = ["GET"]
  memory_size  = 1769
  lambda_environment_variables = {
    LLOYD_GEORGE_DYNAMODB_NAME = "${terraform.workspace}_${var.lloyd_george_dynamodb_table_name}"
    STATISTICAL_REPORTS_BUCKET = "${terraform.workspace}-${var.statistical_reports_bucket_name}"
    PRESIGNED_ASSUME_ROLE      = aws_iam_role.ods_report_presign_url_role.arn
  }
  api_execution_arn = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
    module.get-report-by-ods-gateway,
    aws_iam_policy.lambda_audit_splunk_sqs_queue_send_policy[0],
    module.ndr-app-config
  ]
}

resource "aws_iam_role_policy_attachment" "policy_audit_get-report-by-ods-lambda" {
  count      = local.is_sandbox ? 0 : 1
  role       = module.get-report-by-ods-lambda.lambda_execution_role_name
  policy_arn = try(aws_iam_policy.lambda_audit_splunk_sqs_queue_send_policy[0].arn, null)
}
