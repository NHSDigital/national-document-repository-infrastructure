module "document_reference_dynamodb_table" {
  source                      = "./modules/dynamo_db"
  table_name                  = var.docstore_dynamodb_table_name
  hash_key                    = "ID"
  deletion_protection_enabled = false
  stream_enabled              = false
  ttl_enabled                 = false

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

module "lloyd_george_reference_dynamodb_table" {
  source                      = "./modules/dynamo_db"
  table_name                  = var.lloyd_george_dynamodb_table_name
  hash_key                    = "ID"
  deletion_protection_enabled = false
  stream_enabled              = false
  ttl_enabled                 = false

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
  stream_enabled              = false
  ttl_enabled                 = false

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


# Run the script to get the environment variables of interest.
# This is a data source, so it will run at plan time.
data "external" "dynamo_tables" {
  program = ["sh", "${path.module}/external_tables.sh"]

  # For Windows (or Powershell core on MacOS and Linux),
  # run a Powershell script instead
  #program = ["${path.module}/env.ps1"]
}