# Resources that are common to pre-prod and prod environments.

resource "aws_iam_role_policy_attachment" "github_actions_pre-prod_prod" {
  count      = local.is_pre-prod_prod ? 1 : 0
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_pre-prod_prod[0].arn
}

resource "aws_iam_policy" "github_actions_pre-prod_prod" {
  count = local.is_pre-prod_prod ? 1 : 0
  name  = "${terraform.workspace}-github-actions-policy-pre-prod_prod"
  path  = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "SNS:TagResource",
          "backup:DescribeBackupJob",
          "backup:TagResource",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:PutResourcePolicy",
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:DeleteBucketPolicy",
          "s3:DeleteObjectTagging",
          "s3:DeleteObjectVersion",
          "s3:DeleteObjectVersionTagging",
          "s3:GetAccelerateConfiguration",
          "s3:GetBucketAcl",
          "s3:GetBucketCORS",
          "s3:GetBucketLogging",
          "s3:GetBucketObjectLockConfiguration",
          "s3:GetBucketOwnershipControls",
          "s3:GetBucketPolicy",
          "s3:GetBucketPublicAccessBlock",
          "s3:GetBucketRequestPayment",
          "s3:GetBucketTagging",
          "s3:GetBucketVersioning",
          "s3:GetBucketWebsite",
          "s3:GetEncryptionConfiguration",
          "s3:GetLifecycleConfiguration",
          "s3:GetReplicationConfiguration",
          "s3:PutBucketAcl",
          "s3:PutBucketCORS",
          "s3:PutBucketLogging",
          "s3:PutBucketNotification",
          "s3:PutBucketOwnershipControls",
          "s3:PutBucketPolicy",
          "s3:PutBucketPublicAccessBlock",
          "s3:PutBucketTagging",
          "s3:PutBucketVersioning",
          "s3:PutIntelligentTieringConfiguration",
          "s3:PutLifecycleConfiguration",
          "sqs:tagqueue"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ecr:BatchDeleteImage",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:ecr:eu-west-2:${data.aws_caller_identity.current.account_id}:repository/ndr-${var.environment}-app",
          "arn:aws:ecr:eu-west-2:${data.aws_caller_identity.current.account_id}:repository/${var.environment}-data-collection"
        ]
      },
    ]
  })
}
