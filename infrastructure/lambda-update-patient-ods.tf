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

    }
}