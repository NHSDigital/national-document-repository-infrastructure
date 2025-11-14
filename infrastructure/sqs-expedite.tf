module "lg_bulk_upload_expedite_metadata_queue" {
  source                 = "./modules/sqs"
  name                   = "lg-bulk-upload-expedite-metadata-queue.fifo"
  max_size_message       = 256 * 1024        # allow message size up to 256 KB
  message_retention      = 60 * 60 * 24 * 14 # 14 days
  environment            = var.environment
  owner                  = var.owner
  max_visibility         = 1020
  enable_fifo            = true
  enable_deduplication   = true
  delay                  = 60
  enable_dlq             = true
  dlq_message_retention  = 1209600 # 14 days
  dlq_visibility_timeout = 60
}

resource "aws_iam_role_policy_attachment" "bulk_upload_lambda_expedite_sqs_attach" {
  role       = aws_iam_role.bulk_upload_lambda.name
  policy_arn = aws_iam_policy.bulk_upload_lambda_expedite_sqs_policy.arn
}
