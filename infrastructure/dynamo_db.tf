module "document_reference_dynamodb_table" {
  source                         = "./modules/dynamo_db"
  table_name                     = var.docstore_dynamodb_table_name
  hash_key                       = "ID"
  deletion_protection_enabled    = local.is_production
  stream_enabled                 = false
  ttl_enabled                    = true
  ttl_attribute_name             = "TTL"
  point_in_time_recovery_enabled = !local.is_sandbox

  attributes = [
    {
      name = "ID"
      type = "S"
    },
    {
      name = "FileLocation"
      type = "S"
    },
    {
      name = "NhsNumber"
      type = "S"
    }
  ]

  global_secondary_indexes = [
    {
      name            = "FileLocationsIndex"
      hash_key        = "FileLocation"
      projection_type = "ALL"
    },
    {
      name            = "NhsNumberIndex"
      hash_key        = "NhsNumber"
      projection_type = "ALL"
    }
  ]

  environment = var.environment
  owner       = var.owner
}

module "cloudfront_edge_dynamodb_table" {
  source                         = "./modules/dynamo_db"
  table_name                     = var.cloudfront_edge_table_name
  hash_key                       = "ID"
  deletion_protection_enabled    = local.is_production
  stream_enabled                 = false
  ttl_enabled                    = true
  ttl_attribute_name             = "TTL"
  point_in_time_recovery_enabled = !local.is_sandbox

  attributes = [
    {
      name = "ID"
      type = "S"
    }
  ]

  environment = var.environment
  owner       = var.owner
}

module "lloyd_george_reference_dynamodb_table" {
  source                         = "./modules/dynamo_db"
  table_name                     = var.lloyd_george_dynamodb_table_name
  hash_key                       = "ID"
  deletion_protection_enabled    = local.is_production
  stream_enabled                 = false
  ttl_enabled                    = true
  ttl_attribute_name             = "TTL"
  point_in_time_recovery_enabled = !local.is_sandbox

  attributes = [
    {
      name = "ID"
      type = "S"
    },
    {
      name = "FileLocation"
      type = "S"
    },
    {
      name = "NhsNumber"
      type = "S"
    }
  ]

  global_secondary_indexes = [
    {
      name            = "FileLocationsIndex"
      hash_key        = "FileLocation"
      projection_type = "ALL"
    },
    {
      name            = "NhsNumberIndex"
      hash_key        = "NhsNumber"
      projection_type = "ALL"
    }
  ]

  environment = var.environment
  owner       = var.owner
}

module "zip_store_reference_dynamodb_table" {
  source                      = "./modules/dynamo_db"
  table_name                  = var.zip_store_dynamodb_table_name
  hash_key                    = "ID"
  deletion_protection_enabled = false
  stream_enabled              = true
  ttl_enabled                 = false

  attributes = [
    {
      name = "ID"
      type = "S"
    },
    {
      name = "JobId"
      type = "S"
    }
  ]

  global_secondary_indexes = [
    {
      name            = "JobIdIndex"
      hash_key        = "JobId"
      projection_type = "ALL"
    }
  ]

  environment = var.environment
  owner       = var.owner
}

module "auth_state_dynamodb_table" {
  source                      = "./modules/dynamo_db"
  table_name                  = var.auth_state_dynamodb_table_name
  hash_key                    = "State"
  deletion_protection_enabled = false
  stream_enabled              = false
  ttl_enabled                 = true
  ttl_attribute_name          = "TimeToExist"
  attributes = [
    {
      name = "State"
      type = "S"
    },
  ]

  global_secondary_indexes = [
    {
      name            = "StateIndex"
      hash_key        = "State"
      projection_type = "ALL"
    }
  ]

  environment = var.environment
  owner       = var.owner
}

module "auth_session_dynamodb_table" {
  source                      = "./modules/dynamo_db"
  table_name                  = var.auth_session_dynamodb_table_name
  hash_key                    = "NDRSessionId"
  deletion_protection_enabled = false
  stream_enabled              = false
  ttl_enabled                 = true
  ttl_attribute_name          = "TimeToExist"
  attributes = [
    {
      name = "NDRSessionId"
      type = "S"
    },
  ]

  global_secondary_indexes = [
    {
      name            = "NDRSessionIdIndex"
      hash_key        = "NDRSessionId"
      projection_type = "ALL"
    }
  ]

  environment = var.environment
  owner       = var.owner
}

module "bulk_upload_report_dynamodb_table" {
  source                         = "./modules/dynamo_db"
  table_name                     = var.bulk_upload_report_dynamodb_table_name
  hash_key                       = "ID"
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
      name = "NhsNumber"
      type = "S"
    },
    {
      name = "Timestamp"
      type = "N"
    },
    {
      name = "Date"
      type = "S"
    }
  ]

  global_secondary_indexes = [
    {
      name            = "NhsNumberIndex"
      hash_key        = "NhsNumber"
      projection_type = "ALL"
    },
    {
      name            = "TimestampIndex"
      hash_key        = "Date"
      range_key       = "Timestamp"
      projection_type = "ALL"
    }
  ]

  environment = var.environment
  owner       = var.owner
}

module "statistics_dynamodb_table" {
  source                         = "./modules/dynamo_db"
  table_name                     = var.statistics_dynamodb_table_name
  hash_key                       = "Date"
  sort_key                       = "StatisticID"
  deletion_protection_enabled    = local.is_production
  stream_enabled                 = false
  ttl_enabled                    = false
  point_in_time_recovery_enabled = !local.is_sandbox

  attributes = [
    {
      name = "Date"
      type = "S"
    },
    {
      name = "StatisticID"
      type = "S"
    },
    {
      name = "OdsCode"
      type = "S"
    }
  ]

  global_secondary_indexes = [
    {
      name            = "OdsCodeIndex"
      hash_key        = "OdsCode"
      range_key       = "Date"
      projection_type = "ALL"
    }
  ]

  environment = var.environment
  owner       = var.owner
}