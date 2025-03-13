module "nhs-oauth-token-generator-lambda" {
  source         = "./modules/lambda"
  name           = "NhsOauthTokenGeneratorLambda"
  handler        = "handlers.nhs_oauth_token_generator_handler.lambda_handler"
  lambda_timeout = 60
  iam_role_policy_documents = [
    aws_iam_policy.ssm_access_policy.policy,
    module.ndr-app-config.app_config_policy
  ]

  rest_api_id       = null
  api_execution_arn = null

  lambda_environment_variables = {
    WORKSPACE = terraform.workspace
  }
  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false
}

# TODO PRMP-1580 Need to add the infra for the CloudWatch alarm in the event of a failure
#  Can probably use bulk-upload-metadata-alarm as a reference
