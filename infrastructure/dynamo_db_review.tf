module "document_upload_review_dynamodb_table" {
  count                          = local.is_production ? 0 : 1
  source                         = "./modules/dynamo_db"
  table_name                     = var.document_review_table_name
  hash_key                       = "ID"
  sort_key                       = "Version"
  deletion_protection_enabled    = local.is_production
  stream_enabled                 = false
  ttl_enabled                    = false
  point_in_time_recovery_enabled = !local.is_sandbox

  attributes = [
    {
      name = "ID"
      type = "S"
    },
    {
      name = "Custodian"
      type = "S"
    },
    {
      name = "NhsNumber"
      type = "S"
    },
    {
      name = "ReviewStatus"
      type = "S"
    },
    {
      name = "Author"
      type = "S"
    },
    {
      name = "Reviewer"
      type = "S"
    },
    {
      name = "ReviewDate"
      type = "N"
    },
    {
      name = "UploadDate"
      type = "N"
    },
    {
      name = "Version"
      type = "N"
    }

  ]

  global_secondary_indexes = [
    {
      name            = "CustodianIndex"
      hash_key        = "Custodian"
      range_key       = "UploadDate"
      projection_type = "ALL"

    },
    {
      name            = "AuthorIndex"
      hash_key        = "Author"
      range_key       = "UploadDate"
      projection_type = "ALL"

    },
    {
      name            = "ReviewStatusIndex"
      hash_key        = "ReviewStatus"
      range_key       = "UploadDate"
      projection_type = "ALL"
    },
    {
      name            = "ReviewerIndex"
      hash_key        = "Reviewer"
      range_key       = "ReviewDate"
      projection_type = "ALL"
    },
    {
      name            = "NhsNumberIndex"
      hash_key        = "NhsNumber"
      range_key       = "UploadDate"
      projection_type = "ALL"
    }
  ]

  environment = var.environment
  owner       = var.owner
}
