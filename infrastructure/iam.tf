resource "aws_iam_policy" "s3_document_data_policy_put_only" {
  name = "${terraform.workspace}_put_document_only_policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
        ],
        "Resource" : ["${module.ndr-bulk-staging-store.bucket_arn}/*", "${module.ndr-document-store.bucket_arn}/*"]
      }
    ]
  })
}

data "aws_iam_policy_document" "assume_role_policy_for_create_lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [module.create-doc-ref-lambda.lambda_execution_role_arn]
    }
  }
}

resource "aws_iam_role" "create_post_pre_sign_url_role" {
  name                = "create_post_pre_sign_url_role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy_for_create_lambda.json
  managed_policy_arns = [aws_iam_policy.s3_document_data_policy_put_only.arn]
}

resource "aws_iam_policy" "s3_document_data_policy_for_stitch_lambda" {
  name = "${terraform.workspace}_get_document_only_policy_for_stitch_lambda"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
        ],
        "Resource" : ["${module.ndr-lloyd-george-store.bucket_arn}/combined_files/*"]
      }
    ]
  })
}

data "aws_iam_policy_document" "assume_role_policy_for_stitch_lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [module.lloyd-george-stitch-lambda.lambda_execution_role_arn]
    }
  }
}

resource "aws_iam_role" "stitch_pre_sign_url_role" {
  name                = "stitch_pre_sign_url_role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy_for_stitch_lambda.json
  managed_policy_arns = [aws_iam_policy.s3_document_data_policy_for_stitch_lambda.arn]
}

resource "aws_iam_policy" "s3_document_data_policy_for_manifest_lambda" {
  name = "${terraform.workspace}_get_document_only_policy_for_manifest_lambda"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
        ],
        "Resource" : ["${module.ndr-zip-request-store.bucket_arn}/*"]
      }
    ]
  })
}

data "aws_iam_policy_document" "assume_role_policy_for_manifest_lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [module.document-manifest-by-nhs-number-lambda.lambda_execution_role_arn]
    }
  }
}

resource "aws_iam_role" "manifest_pre_sign_url_role" {
  name                = "manifest_pre_sign_url_role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy_for_manifest_lambda.json
  managed_policy_arns = [aws_iam_policy.s3_document_data_policy_for_manifest_lambda.arn]
}