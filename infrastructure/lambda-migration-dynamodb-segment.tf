module "migration-dynamodb-segment-lambda" {
  source         = "./modules/lambda"
  name           = "MigrationDynamodbSegment"
  handler        = "handlers.migration_dynamodb_segment_handler.lambda_handler"
  lambda_timeout = 900
  iam_role_policy_documents = [
    module.migration-dynamodb-segment-store.s3_read_policy_document,
    module.migration-dynamodb-segment-store.s3_write_policy_document,
    data.aws_iam_policy_document.migration_dynamodb_access.json
  ]
  kms_deletion_window = var.kms_deletion_window

  lambda_environment_variables = {
    WORKSPACE                     = terraform.workspace
    MIGRATION_SEGMENT_BUCKET_NAME = "${terraform.workspace}-${var.migration_dynamodb_segment_store_bucket_name}"
  }
  is_gateway_integration_needed = false
  is_invoked_from_gateway       = false
}

data "aws_iam_policy_document" "migration_dynamodb_access" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeTable"
    ]
    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${terraform.workspace}_*"
    ]
  }
}
