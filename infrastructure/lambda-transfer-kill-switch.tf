module "transfer_kill_switch_lambda" {
  count   = 1
  source  = "./modules/lambda"
  name    = "TransferKillSwitch"
  handler = "handlers.transfer_kill_switch_handler.lambda_handler"

  iam_role_policy_documents = [
    aws_iam_policy.transfer_kill_switch_policy.policy,
    data.aws_iam_policy.aws_lambda_vpc_access_execution_role.policy,
  ]

  kms_deletion_window = var.kms_deletion_window

  rest_api_id       = null
  resource_id       = null
  http_methods      = []
  api_execution_arn = null

  lambda_environment_variables = {
    WORKSPACE                 = terraform.workspace
    STAGING_STORE_BUCKET_NAME = "${terraform.workspace}-${var.staging_store_bucket_name}"
  }

  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false

  lambda_timeout                 = 60
  memory_size                    = 128
  reserved_concurrent_executions = -1

  vpc_subnet_ids         = length(data.aws_security_groups.virus_scanner_api.ids) == 1 ? module.ndr-vpc-ui.private_subnets : []
  vpc_security_group_ids = length(data.aws_security_groups.virus_scanner_api.ids) == 1 ? [data.aws_security_groups.virus_scanner_api.ids[0]] : []

  depends_on = [
    aws_iam_policy.transfer_kill_switch_policy,
    # aws_transfer_server.your_transfer_server,  # if transfer family is ever defined in terraform
    aws_api_gateway_rest_api.ndr_doc_store_api,
    module.ndr-bulk-staging-store,
    module.ndr-lloyd-george-store,
    module.lloyd_george_reference_dynamodb_table,
  ]
}
