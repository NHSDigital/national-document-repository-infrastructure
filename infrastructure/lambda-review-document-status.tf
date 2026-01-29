module "review-document-status-check-lambda" {
  source  = "./modules/lambda"
  name    = "ReviewDocumentStatusCheck"
  handler = "handlers.review_document_status_check_handler.lambda_handler"
  iam_role_policy_documents = [
    module.ndr-app-config.app_config_policy,
    aws_iam_policy.ssm_access_policy.policy,
    module.document_upload_review_dynamodb_table.dynamodb_read_policy_document,
  ]
  kms_deletion_window = var.kms_deletion_window
  rest_api_id         = aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id         = module.review_document_status_gateway.gateway_resource_id
  http_methods        = ["GET"]
  api_execution_arn   = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  lambda_environment_variables = {
    APPCONFIG_APPLICATION         = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT         = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION       = module.ndr-app-config.app_config_configuration_profile_id
    DOCUMENT_REVIEW_DYNAMODB_NAME = module.document_upload_review_dynamodb_table.table_name
    WORKSPACE                     = terraform.workspace
    PDS_FHIR_IS_STUBBED           = local.is_sandbox
  }

  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
    module.review_document_status_gateway
  ]
}

module "review-document-status-check-lambda-alarm" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.review-document-status-check-lambda.function_name
  lambda_timeout       = module.review-document-status-check-lambda.timeout
  lambda_name          = "review_document_status_check_handler"
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.review-document-status-check-alarm-topic.arn]
  ok_actions           = [module.review-document-status-check-alarm-topic.arn]
}

module "review-document-status-check-alarm-topic" {
  source                 = "./modules/sns"
  sns_encryption_key_id  = module.sns_encryption_key.id
  topic_name             = "search-document-review-lambda-alarm-topic"
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
