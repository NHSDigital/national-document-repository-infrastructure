module "update-patient-ods-lambda" {
    source = "./modules/lambda"
    name = "UpdatePatientOdsLambda"
    handler = "handlers.update_patient_ods_handler.lambda_handler"
    iam_role_policies = [
      "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
      "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
      module.lloyd_george_reference_dynamodb_table.dynamodb_policy,  
      module.ndr-app-config.app_config_policy_arn
    ]
    rest_api_id =       null
    api_execution_arn = null

    lambda_environment_variables = {
        APPCONFIG_APPLICATION      = module.ndr-app-config.app_config_application_id
        APPCONFIG_ENVIRONMENT      = module.ndr-app-config.app_config_environment_id
        APPCONFIG_CONFIGURATION    = module.ndr-app-config.app_config_configuration_profile_id
        WORKSPACE                  = terraform.workspace
        LLOYD_GEORGE_DYNAMODB_NAME = "${terraform.workspace}_${var.lloyd_george_dynamodb_table_name}"
        //PDS_FHIR_IS_STUBBED        = local.is_sandbox
    }
    is_gateway_integration_needed = false
    is_invoked_from_gateway       = false
    memory_size                   = 512
    //lambda_timeout                = 45

    depends_on = [
        module.ndr-lloyd_george_reference_dynamodb_table
        module.ndr-app-config
    ]
}