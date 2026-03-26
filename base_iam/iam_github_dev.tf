# Resources that are specific to the dev environment only.

resource "aws_iam_role_policy_attachment" "github_actions_dev" {
  count      = local.is_dev ? 1 : 0
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_dev[0].arn
}

resource "aws_iam_policy" "github_actions_dev" {
  count = local.is_dev ? 1 : 0
  name  = "${terraform.workspace}-github-actions-policy-dev"
  path  = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudfront:*",
          "cognito-idp:*",
          "config:DeleteConfigurationRecorder",
          "config:DeleteDeliveryChannel",
          "config:DescribeConfigurationRecorderStatus",
          "config:PutConfigurationRecorder",
          "config:PutDeliveryChannel",
          "config:StartConfigurationRecorder",
          "config:StopConfigurationRecorder",
          "dynamodb:BatchWriteItem",
          "ec2:DeleteTags",
          "organizations:ListAWSServiceAccessForOrganization"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "kms:GenerateDataKey"
        Effect   = "Allow"
        Resource = "*"
        Condition = {
          StringLike = {
            "aws:ResourceTag/Name" = "alias/mns-notification-encryption-key-kms-*"
          }
        }
      },
      {
        Action   = "apigateway:SetWebACL"
        Effect   = "Allow"
        Resource = "arn:aws:apigateway:eu-west-2::/restapis/*/stages/*"
      },
      {
        Action = [
          "cloudtrail:AddTags",
          "cloudtrail:CreateTrail",
          "cloudtrail:DeleteTrail",
          "cloudtrail:StartLogging"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:cloudtrail:eu-west-2:${data.aws_caller_identity.current.account_id}:channel/*",
          "arn:aws:cloudtrail:eu-west-2:${data.aws_caller_identity.current.account_id}:eventdatastore/*",
          "arn:aws:cloudtrail:eu-west-2:${data.aws_caller_identity.current.account_id}:trail/*"
        ]
      },
      {
        Action = [
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateTimeToLive"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:dynamodb:*:*:table/ndr-terraform-locks"
      },
      {
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:ecr:eu-west-2:*:repository/*"
      },
      {
        Action   = "iam:ListRoles"
        Effect   = "Allow"
        Resource = "arn:aws:lambda:eu-west-2:*:function:*"
      },
      {
        Action   = "logs:PutDeliverySource"
        Effect   = "Allow"
        Resource = "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:delivery-source:*"
      },
      {
        Action   = "s3:ListBucket"
        Effect   = "Allow"
        Resource = "arn:aws:s3:::ndr-dev-terraform-state-${data.aws_caller_identity.current.account_id}"
      },
      {
        Action = [
          "s3:DeleteBucketPolicy",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutBucketPolicy",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::ndr-dev-terraform-state-${data.aws_caller_identity.current.account_id}/ndr/terraform.tfstate"
      },
      {
        Action   = "sqs:SendMessage"
        Effect   = "Allow"
        Resource = "arn:aws:sqs:eu-west-2:${data.aws_caller_identity.current.account_id}:*-mns-notification-queue"
      },
    ]
  })
}
