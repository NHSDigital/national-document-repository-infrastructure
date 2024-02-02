locals {
  ses_feedback_sender_email_address = (
    local.is_production ? "feedback@${var.certificate_domain}" :
    local.is_sandbox ? "feedback@ndr-dev.${var.domain}" :
    "feedback@${terraform.workspace}.${var.domain}"
  )
  feedback_recipient_list_ssm_param_key = (local.is_sandbox
    ? "/prs/dev/user-input/feedback-recipient-email-list"
    : "/prs/${var.environment}/user-input/feedback-recipient-email-list"
  )
}

module "send-feedback-gateway" {
  # Gateway Variables
  source              = "./modules/gateway"
  api_gateway_id      = aws_api_gateway_rest_api.ndr_doc_store_api.id
  parent_id           = aws_api_gateway_rest_api.ndr_doc_store_api.root_resource_id
  http_method         = "POST"
  authorization       = "CUSTOM"
  gateway_path        = "Feedback"
  authorizer_id       = aws_api_gateway_authorizer.repo_authoriser.id
  require_credentials = true
  origin              = "'https://${terraform.workspace}.${var.domain}'"

  # Lambda Variables
  api_execution_arn = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  owner             = var.owner
  environment       = var.environment

  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
  ]
}

module "send-feedback-alarm" {
  source               = "./modules/lambda_alarms"
  lambda_function_name = module.send-feedback-lambda.function_name
  lambda_timeout       = module.send-feedback-lambda.timeout
  lambda_name          = "send_feedback_handler"
  namespace            = "AWS/Lambda"
  alarm_actions        = [module.send-feedback-alarm-topic.arn]
  ok_actions           = [module.send-feedback-alarm-topic.arn]
  depends_on           = [module.send-feedback-lambda, module.send-feedback-alarm-topic]
}

module "send-feedback-alarm-topic" {
  source                = "./modules/sns"
  sns_encryption_key_id = module.sns_encryption_key.id
  current_account_id    = data.aws_caller_identity.current.account_id
  topic_name            = "send-feedback-topic"
  topic_protocol        = "lambda"
  topic_endpoint        = module.send-feedback-lambda.endpoint
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

  depends_on = [module.send-feedback-lambda, module.sns_encryption_key]
}

module "send-feedback-lambda" {
  source  = "./modules/lambda"
  name    = "SendFeedbackLambda"
  handler = "handlers.send_feedback_handler.lambda_handler"
  iam_role_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
    aws_iam_policy.ssm_policy_pds.arn,
    aws_iam_policy.ses_send_email_policy.arn
  ]
  rest_api_id       = aws_api_gateway_rest_api.ndr_doc_store_api.id
  resource_id       = module.send-feedback-gateway.gateway_resource_id
  http_method       = "POST"
  api_execution_arn = aws_api_gateway_rest_api.ndr_doc_store_api.execution_arn
  lambda_environment_variables = {
    WORKSPACE                     = terraform.workspace,
    FROM_EMAIL_ADDRESS            = local.ses_feedback_sender_email_address
    EMAIL_SUBJECT                 = "Digitised Lloyd George feedback"
    EMAIL_RECIPIENT_SSM_PARAM_KEY = local.feedback_recipient_list_ssm_param_key
  }
  depends_on = [
    aws_api_gateway_rest_api.ndr_doc_store_api,
    module.send-feedback-gateway,
    module.ndr-feedback-mailbox
  ]
}

resource "aws_iam_policy" "ses_send_email_policy" {
  name = "${terraform.workspace}_ses_send_email_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ses:SendEmail",
        ],
        Resource = [
          "arn:aws:ses:${local.current_region}:${local.current_account_id}:identity/*",
        ]
      }
    ]
  })
}
