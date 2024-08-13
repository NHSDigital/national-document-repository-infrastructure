module "edge_presign_alarm" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.edge-presign-lambda.function_name
  lambda_timeout       = module.edge-presign-lambda.timeout
  lambda_name          = "edge_presign_reference_handler"
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.edge_presign_alarm_topic.arn]
  ok_actions           = [module.edge_presign_alarm_topic.arn]
  depends_on           = [module.edge-presign-lambda, module.edge_presign_alarm_topic]
}


module "edge_presign_alarm_topic" {
  source                = "./modules/sns"
  sns_encryption_key_id = module.sns_encryption_key.id
  current_account_id    = data.aws_caller_identity.current.account_id
  topic_name            = "edge_presign-alarms-topic"
  topic_protocol        = "lambda"
  topic_endpoint        = module.edge-presign-lambda.lambda_arn
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

module "edge-presign-lambda" {
  source  = "./modules/lambda"
  name    = "EdgePresignLambda"
  handler = "handlers.edge_presign_reference_handler.lambda_handler"
  iam_role_policies = [
    module.lloyd_george_reference_dynamodb_table.dynamodb_policy,
    module.ndr-lloyd-george-store.s3_object_access_policy,
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
    aws_iam_policy.ssm_access_policy.arn,
    module.ndr-app-config.app_config_policy_arn,
  ]
  rest_api_id                   = local.is_production ? null : aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id                   = local.is_production ? null : module.edge-presign-gateway.gateway_resource_id
  api_execution_arn             = local.is_production ? null : aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false
  http_methods                  = ["POST", "GET"]
  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
    module.ndr-bulk-staging-store,
    module.edge-presign-gateway,
    module.ndr-app-config,
  ]
}
