module "mns-notification-lambda"{
    source  = "./modules/lambda"
    name    = "MNSNotificationLambda"
    handler = "handlers.mns_notification_lambda.lambda_handler"
     iam_role_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
    aws_sqs_queue_policy.mns_sqs_access_policy.arn
    module.lloyd_george_reference_dynamodb_table.dynamodb_policy,
    aws_iam_policy.ssm_access_policy.arn,
    module.ndr-app-config.app_config_policy_arn
  ]
  rest_api_id       = null
  api_execution_arn = null
}