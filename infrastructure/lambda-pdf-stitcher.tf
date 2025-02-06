module "pdf-stitching-lambda" {
  source         = "./modules/lambda"
  name           = "PDF Stitching Lambda"
  handler        = "handlers.pdf-stitching-lambda.lambda_handler"
  lambda_timeout = 900
  iam_role_policy_documents = [
    module.ndr-lloyd-george-store.s3_write_policy_document,
    module.ndr-bulk-staging-store.s3_read_policy_document,
    module.sqs-nrl-queue.sqs_write_policy_document,
    module.sqs-stitching-queue-deadletter.sqs_write_policy_document
    ]
  rest_api_id       = null
  api_execution_arn = null
  
  
  
  }