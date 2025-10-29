module "put_document_review_lambda" {
  source  = "./modules/lambda"
  name    = "PutDocumentReview"
  handler = "handlers.put_document_review_handler.lambda_handler"
  iam_role_policy_documents = [
    module.ndr-app-config.app_config_policy,
  ]

  rest_api_id                   = aws_api_gateway_rest_api.ndr_doc_store_api.id
  api_execution_arn             = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  http_methods                  = ["GET"]
  resource_id                   = module.review_document_gateway.gateway_resource_id
  kms_deletion_window           = var.kms_deletion_window
  is_gateway_integration_needed = true
  is_invoked_from_gateway       = true
  lambda_environment_variables = {
    APPCONFIG_APPLICATION       = module.ndr-app-config.app_config_application_id
    APPCONFIG_ENVIRONMENT       = module.ndr-app-config.app_config_environment_id
    APPCONFIG_CONFIGURATION     = module.ndr-app-config.app_config_configuration_profile_id
    DOCUMENT_REVIEW_DYNAMO_NAME = ""
    WORKSPACE                   = terraform.workspace


  }
  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
    module.review_document_gateway
  ]
}


module "put_document_review_lambda_alarm" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.put_document_review_lambda.function_name
  lambda_timeout       = module.put_document_review_lambda.timeout
  lambda_name          = "put_document_review_handler"
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.put_document_review_lambda_alarm_topic.arn]
  ok_actions           = [module.put_document_review_lambda_alarm_topic.arn]
}


module "put_document_review_lambda_alarm_topic" {
  source                = "./modules/sns"
  sns_encryption_key_id = module.sns_encryption_key.id
  topic_name            = "put-document-review-lambda-alarm-topic"
  topic_protocol        = "lambda"
  topic_endpoint        = module.put_document_review_lambda.lambda_arn
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

