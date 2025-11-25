module "get-doc-ref-alarm" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.get-doc-ref-lambda.function_name
  lambda_timeout       = module.get-doc-ref-lambda.timeout
  lambda_name          = "get_document_reference_handler"
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.get-doc-ref-alarm-topic.arn]
  ok_actions           = [module.get-doc-ref-alarm-topic.arn]
  depends_on           = [module.get-doc-ref-lambda, module.get-doc-ref-alarm-topic]
}

module "get-doc-ref-alarm-topic" {
  source                = "./modules/sns"
  sns_encryption_key_id = module.sns_encryption_key.id
  topic_name            = "get_doc-alarms-topic"
  topic_protocol        = "lambda"
  topic_endpoint        = module.get-doc-ref-lambda.lambda_arn
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

module "get-doc-ref-lambda" {
  source  = "./modules/lambda"
  name    = "GetDocRefLambda"
  handler = "handlers.get_document_reference_handler.lambda_handler"
  iam_role_policy_documents = [
    module.ndr-lloyd-george-store.s3_read_policy_document,
    module.lloyd_george_reference_dynamodb_table.dynamodb_read_policy_document,
    aws_iam_policy.ssm_access_policy.policy,
    module.ndr-app-config.app_config_policy,
    module.cloudfront_edge_dynamodb_table.dynamodb_write_policy_document
  ]
  kms_deletion_window = var.kms_deletion_window
  rest_api_id         = aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id         = module.document_reference_id_gateway.gateway_resource_id
  http_methods        = ["GET"]

  api_execution_arn = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  lambda_environment_variables = {
    APPCONFIG_APPLICATION      = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT      = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION    = module.ndr-app-config.app_config_configuration_profile_id
    LLOYD_GEORGE_DYNAMODB_NAME = module.lloyd_george_reference_dynamodb_table.table_name
    PDS_FHIR_IS_STUBBED        = local.is_sandbox
    WORKSPACE                  = terraform.workspace
    PRESIGNED_ASSUME_ROLE      = aws_iam_role.get_doc_ref_presign_url_role.arn
    EDGE_REFERENCE_TABLE       = module.cloudfront_edge_dynamodb_table.table_name
    CLOUDFRONT_URL             = module.cloudfront-distribution-lg.cloudfront_url
  }
  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
    module.cloudfront-distribution-lg,
    module.document_reference_id_gateway
  ]
}
