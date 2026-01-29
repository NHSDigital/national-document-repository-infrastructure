module "post_document_review_lambda" {
  source  = "./modules/lambda"
  name    = "PostDocumentReview"
  handler = "handlers.post_document_review_handler.lambda_handler"
  iam_role_policy_documents = [
    module.ndr-app-config.app_config_policy,
    module.document_upload_review_dynamodb_table.dynamodb_write_policy_document,
    module.document_upload_review_dynamodb_table.dynamodb_read_policy_document,
    aws_iam_policy.ssm_access_policy.policy,
    module.ndr-bulk-staging-store.s3_write_policy_document,
    module.cloudfront_edge_dynamodb_table.dynamodb_write_policy_document,
  ]

  rest_api_id                   = aws_api_gateway_rest_api.ndr_doc_store_api.id
  api_execution_arn             = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  http_methods                  = ["POST"]
  resource_id                   = module.review_document_gateway.gateway_resource_id
  kms_deletion_window           = var.kms_deletion_window
  is_gateway_integration_needed = true
  is_invoked_from_gateway       = true
  lambda_environment_variables = {
    APPCONFIG_APPLICATION         = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT         = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION       = module.ndr-app-config.app_config_configuration_profile_id
    DOCUMENT_REVIEW_DYNAMODB_NAME = module.document_upload_review_dynamodb_table.table_name
    PRESIGNED_ASSUME_ROLE         = aws_iam_role.post_document_review_presign.arn
    WORKSPACE                     = terraform.workspace
    STAGING_STORE_BUCKET_NAME     = module.ndr-bulk-staging-store.bucket_id
    EDGE_REFERENCE_TABLE          = module.cloudfront_edge_dynamodb_table.table_name
    CLOUDFRONT_URL                = one(aws_cloudfront_distribution.s3_presign_mask.aliases)
    PDS_FHIR_IS_STUBBED           = local.is_sandbox
  }
  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
    module.review_document_gateway
  ]
}


module "post_document_review_lambda_alarm" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.post_document_review_lambda.function_name
  lambda_timeout       = module.post_document_review_lambda.timeout
  lambda_name          = "post_document_review_handler"
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.post_document_review_lambda_alarm_topic.arn]
  ok_actions           = [module.post_document_review_lambda_alarm_topic.arn]
}


module "post_document_review_lambda_alarm_topic" {
  source                 = "./modules/sns"
  sns_encryption_key_id  = module.sns_encryption_key.id
  topic_name             = "post-document-review-lambda-alarm-topic"
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

