module "lg_bulk_upload_expedite_metadata_queue" {
  source                 = "./modules/sqs"
  name                   = "lg-bulk-upload-expedite-metadata-queue.fifo"
  environment            = var.environment
  owner                  = var.owner
  enable_fifo            = true
  enable_deduplication   = true
  receive_wait           = 0
  enable_sse             = true
  kms_master_key_id      = null
  enable_dlq             = true
  dlq_message_retention  = 1209600 # 14 days
  dlq_visibility_timeout = 60
  max_receive_count      = 5
}

resource "aws_iam_role_policy_attachment" "bulk_upload_lambda_expedite_sqs_attach" {
  role       = aws_iam_role.bulk_upload_lambda.name
  policy_arn = aws_iam_policy.bulk_upload_lambda_expedite_sqs_policy.arn
}
