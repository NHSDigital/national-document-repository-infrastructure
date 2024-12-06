module "bulk-upload-lambda" {
  source  = "./modules/lambda"
  name    = "BulkUploadLambda"
  handler = "handlers.bulk_upload_handler.lambda_handler"
  iam_role_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
    module.ndr-app-config.app_config_policy_arn,
    aws_iam_policy.ssm_access_policy.arn,
    aws_iam_policy.lambda_sqs_combined_policy.arn,
    module.ndr-bulk-staging-store.s3_object_access_policy,
    module.ndr-lloyd-george-store.s3_object_access_policy,
    module.lloyd_george_reference_dynamodb_table.dynamodb_policy,
    module.bulk_upload_report_dynamodb_table.dynamodb_policy,
  ]
  rest_api_id       = null
  api_execution_arn = null

  lambda_environment_variables = {
    APPCONFIG_APPLICATION      = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT      = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION    = module.ndr-app-config.app_config_configuration_profile_id
    WORKSPACE                  = terraform.workspace
    STAGING_STORE_BUCKET_NAME  = "${terraform.workspace}-${var.staging_store_bucket_name}"
    LLOYD_GEORGE_BUCKET_NAME   = "${terraform.workspace}-${var.lloyd_george_bucket_name}"
    LLOYD_GEORGE_DYNAMODB_NAME = "${terraform.workspace}_${var.lloyd_george_dynamodb_table_name}"
    BULK_UPLOAD_DYNAMODB_NAME  = "${terraform.workspace}_${var.bulk_upload_report_dynamodb_table_name}"
    METADATA_SQS_QUEUE_URL     = module.sqs-lg-bulk-upload-metadata-queue.sqs_url
    INVALID_SQS_QUEUE_URL      = module.sqs-lg-bulk-upload-invalid-queue.sqs_url
    PDS_FHIR_IS_STUBBED        = local.is_sandbox
    NRL_SQS_URL                = module.sqs-nrl-queue.sqs_url
    APIM_API_URL               = data.aws_ssm_parameter.apim_url.value
  }

  is_gateway_integration_needed  = false
  is_invoked_from_gateway        = false
  memory_size                    = 512
  lambda_timeout                 = 900
  reserved_concurrent_executions = local.bulk_upload_lambda_concurrent_limit

  depends_on = [
    module.ndr-bulk-staging-store,
    module.sqs-lg-bulk-upload-metadata-queue,
    module.sqs-lg-bulk-upload-invalid-queue,
    module.ndr-lloyd-george-store,
    module.lloyd_george_reference_dynamodb_table,
    module.bulk_upload_report_dynamodb_table,
    aws_iam_policy.ssm_access_policy,
    module.ndr-app-config
  ]
}


resource "aws_lambda_event_source_mapping" "bulk_upload_lambda" {
  event_source_arn = module.sqs-lg-bulk-upload-metadata-queue.endpoint
  function_name    = module.bulk-upload-lambda.lambda_arn

  scaling_config {
    maximum_concurrency = local.bulk_upload_lambda_concurrent_limit
  }

  depends_on = [
    module.bulk-upload-lambda,
    module.sqs-lg-bulk-upload-metadata-queue
  ]
}

module "bulk-upload-alarm" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.bulk-upload-lambda.function_name
  lambda_timeout       = module.bulk-upload-lambda.timeout
  lambda_name          = "bulk_upload_handler"
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.bulk-upload-alarm-topic.arn]
  ok_actions           = [module.bulk-upload-alarm-topic.arn]
  depends_on           = [module.bulk-upload-lambda, module.bulk-upload-alarm-topic]
}

module "bulk-upload-alarm-topic" {
  source                = "./modules/sns"
  sns_encryption_key_id = module.sns_encryption_key.id
  current_account_id    = data.aws_caller_identity.current.account_id
  topic_name            = "bulk-upload-topic"
  topic_protocol        = "lambda"
  topic_endpoint        = module.bulk-upload-lambda.lambda_arn
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

  depends_on = [module.bulk-upload-lambda, module.sns_encryption_key]
}