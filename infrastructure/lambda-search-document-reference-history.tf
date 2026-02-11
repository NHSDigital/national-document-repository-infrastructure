module "search_document_reference_history_lambda" {
  source  = "./modules/lambda"
  name    = "SearchDocumentReferenceHistory"
  handler = "handlers.search_document_reference_history_handler.lambda_handler"
  iam_role_policy_documents = [
    module.document_reference_dynamodb_table.dynamodb_read_policy_document,
    module.document_reference_dynamodb_table.dynamodb_write_policy_document,
    module.lloyd_george_reference_dynamodb_table.dynamodb_read_policy_document,
    module.lloyd_george_reference_dynamodb_table.dynamodb_write_policy_document,
    module.ndr-lloyd-george-store.s3_read_policy_document,
    module.ndr-document-store.s3_read_policy_document,
    module.ndr-app-config.app_config_policy,
    aws_iam_policy.ssm_access_policy.policy
  ]
  kms_deletion_window = var.kms_deletion_window
  rest_api_id         = aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id         = module.document_reference_history_gateway.gateway_resource_id
  http_methods        = ["GET"]
  api_execution_arn   = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn

  depends_on = [
    module.document_reference_history_gateway,
    module.document_reference_dynamodb_table,
    module.lloyd_george_reference_dynamodb_table,
    module.ndr-lloyd-george-store,
    module.ndr-document-store,
    module.ndr-app-config,
    aws_iam_policy.ssm_access_policy
  ]
}

module "search_document_reference_history_lambda_alarm" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.search_document_reference_history_lambda.function_name
  lambda_timeout       = module.search_document_reference_history_lambda.timeout
  lambda_name          = "search_document_reference_history_handler"
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.search_document_reference_history_lambda_alarm_topic.arn]
  ok_actions           = [module.search_document_reference_history_lambda_alarm_topic.arn]
}

module "search_document_reference_history_lambda_alarm_topic" {
  source                 = "./modules/sns"
  sns_encryption_key_id  = module.sns_encryption_key.id
  topic_name             = "search-document-reference-history-lambda-alarm-topic"
  topic_protocol         = "email"
  is_topic_endpoint_list = true
  topic_endpoint_list    = local.is_sandbox ? [] : nonsensitive(split(",", data.aws_ssm_parameter.cloud_security_notification_email_list.value))
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