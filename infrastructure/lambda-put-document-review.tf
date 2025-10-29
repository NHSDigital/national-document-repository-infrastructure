module "put-document-review-lambda" {
  source  = "./modules/lambda"
  name    = "PutDocumentReview"
  handler = "handlers.put_document_review_handler.lambda_handler"
  iam_role_policy_documents = [
    module.ndr-app-config.app_config_policy,
  ]

  rest_api_id                   = aws_api_gateway_rest_api.ndr_doc_store_api.id
  api_execution_arn             = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  http_methods                  = ["GET"]
  resource_id                   = module.put-document-review-gateway.gateway_resource_id
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
    module.put-document-review-gateway
  ]
}

module "put-document-review-gateway" {
  source              = "./modules/gateway"
  api_gateway_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id           = aws_api_gateway_rest_api.ndr_doc_store_api.root_resource_id
  http_methods        = ["GET"]
  authorizer_id       = aws_api_gateway_authorizer.repo_authoriser.id
  authorization       = "CUSTOM"
  require_credentials = true
  origin              = contains(["prod"], terraform.workspace) ? "'https://${var.domain}'" : "'https://${terraform.workspace}.${var.domain}'"
  gateway_path        = "PutDocumentReview"
}

module "put-document-review-lambda-alarm" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.put-document-review-lambda.function_name
  lambda_timeout       = module.put-document-review-lambda.timeout
  lambda_name          = "put_document_review_handler"
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.put-document-review-lambda-alarm-topic.arn]
  ok_actions           = [module.put-document-review-lambda-alarm-topic.arn]
}


module "put-document-review-lambda-alarm-topic" {
  source                = "./modules/sns"
  sns_encryption_key_id = module.sns_encryption_key.id
  topic_name            = "put-document-review-lambda-alarm-topic"
  topic_protocol        = "lambda"
  topic_endpoint        = module.put-document-review-lambda.lambda_arn
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

