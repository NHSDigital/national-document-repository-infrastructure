module "generate-document-manifest-alarm" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.generate-document-manifest-lambda.function_name
  lambda_timeout       = module.generate-document-manifest-lambda.timeout
  lambda_name          = "generate_document_manifest_handler"
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.generate-document-manifest-alarm-topic.arn]
  ok_actions           = [module.generate-document-manifest-alarm-topic.arn]
  depends_on           = [module.generate-document-manifest-lambda, module.generate-document-manifest-alarm-topic]
}

module "generate-document-manifest-alarm-topic" {
  source                = "./modules/sns"
  sns_encryption_key_id = module.sns_encryption_key.id
  current_account_id    = data.aws_caller_identity.current.account_id
  topic_name            = "generate-document-manifest-topic"
  topic_protocol        = "lambda"
  topic_endpoint        = module.generate-document-manifest-lambda.lambda_arn
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

  depends_on = [module.generate-document-manifest-lambda, module.sns_encryption_key]
}

module "generate-document-manifest-lambda" {
  source                   = "./modules/lambda"
  name                     = "GenerateDocumentManifest"
  handler                  = "handlers.generate_document_manifest_handler.lambda_handler"
  lambda_timeout           = 900
  lambda_ephemeral_storage = 512
  memory_size              = 512
  iam_role_policies = [
    module.document_reference_dynamodb_table.dynamodb_policy,
    module.ndr-document-store.s3_object_access_policy,
    module.lloyd_george_reference_dynamodb_table.dynamodb_policy,
    module.ndr-lloyd-george-store.s3_object_access_policy,
    module.zip_store_reference_dynamodb_table.dynamodb_policy,
    module.ndr-zip-request-store.s3_object_access_policy,
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
    module.ndr-app-config.app_config_policy_arn,
    aws_iam_policy.dynamodb_stream_policy.arn
  ]
  rest_api_id       = null
  api_execution_arn = null
  lambda_environment_variables = {
    APPCONFIG_APPLICATION        = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT        = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION      = module.ndr-app-config.app_config_configuration_profile_id
    DOCUMENT_STORE_BUCKET_NAME   = "${terraform.workspace}-${var.docstore_bucket_name}"
    DOCUMENT_STORE_DYNAMODB_NAME = "${terraform.workspace}_${var.docstore_dynamodb_table_name}"
    LLOYD_GEORGE_BUCKET_NAME     = "${terraform.workspace}-${var.lloyd_george_bucket_name}"
    LLOYD_GEORGE_DYNAMODB_NAME   = "${terraform.workspace}_${var.lloyd_george_dynamodb_table_name}"
    ZIPPED_STORE_BUCKET_NAME     = "${terraform.workspace}-${var.zip_store_bucket_name}"
    ZIPPED_STORE_DYNAMODB_NAME   = "${terraform.workspace}_${var.zip_store_dynamodb_table_name}"
    SPLUNK_SQS_QUEUE_URL         = try(module.sqs-splunk-queue[0].sqs_url, null)
    WORKSPACE                    = terraform.workspace
    PRESIGNED_ASSUME_ROLE        = aws_iam_role.manifest_presign_url_role.arn
  }
  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false

  depends_on = [
    aws_iam_policy.lambda_audit_splunk_sqs_queue_send_policy[0],
    module.ndr-app-config
  ]
}

resource "aws_iam_policy" "dynamodb_stream_policy" {
  name = "${terraform.workspace}_dynamodb_stream_to_manifest_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["dynamodb:GetRecords", "dynamodb:GetShardIterator", "dynamodb:DescribeStream", "dynamodb:ListStreams"]
        Effect   = "Allow"
        Resource = module.zip_store_reference_dynamodb_table.dynamodb_stream_arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_generate_manifest_lambda" {
  count      = local.is_sandbox ? 0 : 1
  role       = module.generate-document-manifest-lambda.lambda_execution_role_name
  policy_arn = try(aws_iam_policy.lambda_audit_splunk_sqs_queue_send_policy[0].arn, null)
}

resource "aws_lambda_event_source_mapping" "dynamodb_stream_event_mapping" {
  event_source_arn  = module.zip_store_reference_dynamodb_table.dynamodb_stream_arn
  function_name     = module.generate-document-manifest-lambda.lambda_arn
  batch_size        = 1
  starting_position = "TRIM_HORIZON"

  filter_criteria {
    filter {
      pattern = jsonencode({
        "eventName" : [
          "INSERT"
        ],
        "dynamodb" : {
          "NewImage" : {
            "JobStatus" : {
              "S" : [
                "Pending"
              ]
            }
          }
        }
      })
    }
  }
}