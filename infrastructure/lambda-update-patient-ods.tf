module "update_patient_ods_lambda" {
  source  = "./modules/lambda"
  name    = "UpdatePatientOdsLambda"
  handler = "handlers.update_patient_ods_handler.lambda_handler"
  iam_role_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
    module.lloyd_george_reference_dynamodb_table.dynamodb_policy,
    module.ndr-app-config.app_config_policy_arn,
    aws_iam_policy.dynamodb_scan_lloyd_george.arn,
    aws_iam_policy.ssm_access_policy.arn
  ]
  rest_api_id       = null
  api_execution_arn = null

  lambda_environment_variables = {
    WORKSPACE                  = terraform.workspace
    LLOYD_GEORGE_DYNAMODB_NAME = "${terraform.workspace}_${var.lloyd_george_dynamodb_table_name}"
    PDS_FHIR_IS_STUBBED        = local.is_sandbox
  }
  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false
  memory_size                   = 512
  lambda_timeout                = 900
}

resource "aws_iam_policy" "dynamodb_scan_lloyd_george" {
  name = "${terraform.workspace}_${var.lloyd_george_dynamodb_table_name}_scan_policy"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:Scan"
        ],
        "Resource" : [
          module.lloyd_george_reference_dynamodb_table.dynamodb_table_arn
        ]
      }
    ]
  })
}

module "update_patient_ods_alarm" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.update_patient_ods_lambda.function_name
  lambda_timeout       = module.update_patient_ods_lambda.timeout
  lambda_name          = "update_patient_ods_handler"
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.update_patient_ods_alarm_topic.arn]
  ok_actions           = [module.update_patient_ods_alarm_topic.arn]
  depends_on           = [module.update_patient_ods_lambda, module.update_patient_ods_alarm_topic]
}

module "update_patient_ods_alarm_topic" {
  source                = "./modules/sns"
  sns_encryption_key_id = module.sns_encryption_key.id
  current_account_id    = data.aws_caller_identity.current.account_id
  topic_name            = "update-patient-ods-alarm-topic"
  topic_protocol        = "lambda"
  topic_endpoint        = module.update_patient_ods_lambda.lambda_arn
  delivery_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudwatch.amazonaws.com"
        },
        "Action" : [
          "SNS:Publish"
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

  depends_on = [module.update_patient_ods_lambda, module.sns_encryption_key]
}