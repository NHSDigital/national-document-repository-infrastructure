module "lg_bulk_upload_expedite_metadata_queue" {
  source                 = "../modules/sqs"
  name                   = "lg-bulk-upload-expedite-metadata-queue.fifo"
  enable_fifo            = true
  enable_deduplication   = true
  message_retention      = 345600 # 4 days
  max_visibility         = 60
  delay                  = 0
  max_size_message       = 262144
  receive_wait           = 0
  enable_sse             = true
  kms_master_key_id      = null
  enable_dlq             = true
  dlq_message_retention  = 1209600 # 14 days
  dlq_visibility_timeout = 60
  max_receive_count      = 5
}

resource "aws_iam_policy" "bulk_upload_lambda_expedite_sqs_policy" {
  name        = "${var.environment}-BulkUploadLambdaExpediteSQSPolicy"
  description = "Allow BulkUploadLambda to send/receive messages from expedite SQS queue"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl"
        ]
        Resource = [
          module.lg_bulk_upload_expedite_metadata_queue.queue_arn,
          module.lg_bulk_upload_expedite_metadata_queue.deadletter_queue_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bulk_upload_lambda_expedite_sqs_attach" {
  role       = aws_iam_role.bulk_upload_lambda.name
  policy_arn = aws_iam_policy.bulk_upload_lambda_expedite_sqs_policy.arn
}
