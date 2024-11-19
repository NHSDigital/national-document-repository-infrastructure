resource "aws_iam_policy" "ssm_access_policy" {
  name = "${terraform.workspace}_ssm_parameters"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:PutParameter"
        ],
        Resource = [
          "arn:aws:ssm:*:*:parameter/*",
        ]
      }
    ]
  })
}

data "aws_iam_policy_document" "combined_sqs_policies" {
  source_policy_documents = [
    module.sqs-lg-bulk-upload-metadata-queue.sqs_policy,
    module.sqs-lg-bulk-upload-invalid-queue.sqs_policy,
    module.sqs-nrl-queue.sqs_policy.json
  ]
}

data "aws_iam_policy_document" "combined_s3_policies" {
  source_policy_documents = [
    module.ndr-bulk-staging-store.s3_object_access_policy,
    module.ndr-lloyd-george-store.s3_object_access_policy
  ]
}

data "aws_iam_policy_document" "combined_dynamodb_policies" {
  source_policy_documents = [
    module.lloyd_george_reference_dynamodb_table.dynamodb_policy,
    module.bulk_upload_report_dynamodb_table.dynamodb_policy
  ]
}

resource "aws_iam_policy" "lambda_sqs_combined_policy" {
  name        = "lambda-sqs-combined-policy"
  description = "Combined SQS policies for Lambda"
  policy      = data.aws_iam_policy_document.combined_sqs_policies.json
}


resource "aws_iam_policy" "lambda_s3_combined_policy" {
  name        = "lambda-sqs-combined-policy"
  description = "Combined S3 policies for Lambda"
  policy      = data.aws_iam_policy_document.combined_s3_policies.json
}

resource "aws_iam_policy" "lambda_dynamodb_combined_policy" {
  name        = "lambda-sqs-combined-policy"
  description = "Combined DynamoDB policies for Lambda"
  policy      = data.aws_iam_policy_document.combined_dynamodb_policies.json
}
