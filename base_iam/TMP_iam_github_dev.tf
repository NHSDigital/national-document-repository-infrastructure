resource "aws_iam_role_policy_attachment" "github_actions_policy_dev" {
count      = local.is_dev ? 1 : 0
role       = aws_iam_role.dev_github_actions.name
policy_arn = aws_iam_policy.github_actions_policy_dev[0].arn
}

resource "aws_iam_policy" "github_actions_policy_dev" {
  count = local.is_dev ? 1 : 0
  name   = "github-actions-policy-dev"
  path   = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "backup:TagResource",
          "backup:UntagResource",
          "cognito-identity:TagResource",
          "cognito-identity:UntagResource",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags",
          "events:TagResource",
          "events:UntagResource",
          "iam:TagPolicy",
          "iam:TagRole",
          "iam:UntagPolicy",
          "iam:UntagRole",
          "lambda:TagResource",
          "lambda:UntagResource",
          "resource-groups:DeleteGroup",
          "resource-groups:GetGroup",
          "resource-groups:GetGroupConfiguration",
          "resource-groups:GetGroupQuery",
          "resource-groups:GetTags",
          "resource-groups:ListGroupResources",
          "resource-groups:Tag",
          "resource-groups:Untag",
          "resource-groups:UpdateGroup",
          "resource-groups:UpdateGroupQuery",
          "sns:TagResource",
          "sns:UntagResource"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:backup-plan:*",
          "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:backup-vault:*",
          "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:framework:*-*",
          "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:legal-hold:*",
          "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:report-plan:*-*",
          "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:restore-testing-plan:*-*",
          "arn:aws:cognito-identity:*:${data.aws_caller_identity.current.account_id}:identitypool/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener-rule/app/*/*/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener-rule/net/*/*/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/app/*/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/gwy/*/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/net/*/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/app/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/gwy/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/net/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:targetgroup/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:truststore/*/*",
          "arn:aws:events:*:${data.aws_caller_identity.current.account_id}:event-bus/*",
          "arn:aws:events:*:${data.aws_caller_identity.current.account_id}:rule/*/*",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/*",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*",
          "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:code-signing-config:*",
          "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:event-source-mapping:*",
          "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:function:*",
          "arn:aws:resource-groups:*:${data.aws_caller_identity.current.account_id}:group/*",
          "arn:aws:sns:*:${data.aws_caller_identity.current.account_id}:*"
        ]
      },
      {
        Action = "logs:PutDeliverySource"
        Effect = "Allow"
        Resource = "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:delivery-source:*"
      },
      {
        Action = [
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateTimeToLive"
        ]
        Effect = "Allow"
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
        Effect = "Allow"
        Resource = "arn:aws:ecr:eu-west-2:*:repository/*"
      },
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
        Effect = "Allow"
        Resource = "*"
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
          "s3:DeleteBucketPolicy",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutBucketPolicy",
          "s3:PutObject"
        ]
        Effect = "Allow"
        Resource = "arn:aws:s3:::ndr-dev-terraform-state-${data.aws_caller_identity.current.account_id}/ndr/terraform.tfstate"
      },
      {
        Action = "s3:ListBucket"
        Effect = "Allow"
        Resource = "arn:aws:s3:::ndr-dev-terraform-state-${data.aws_caller_identity.current.account_id}"
      },
      {
        Action = "iam:ListRoles"
        Effect = "Allow"
        Resource = "arn:aws:lambda:eu-west-2:*:function:*"
      },
      {
        Action = "kms:GenerateDataKey"
        Effect = "Allow"
        Resource = "*"
        Condition = {
          StringLike = {
          "aws:ResourceTag/Name" = "alias/mns-notification-encryption-key-kms-*"
          }
        }
      },
      {
        Action = "sqs:SendMessage"
        Effect = "Allow"
        Resource = "arn:aws:sqs:eu-west-2:${data.aws_caller_identity.current.account_id}:*-mns-notification-queue"
      },
      {
        Action = "apigateway:SetWebACL"
        Effect = "Allow"
        Resource = "arn:aws:apigateway:eu-west-2::/restapis/*/stages/*"
      },
    ]
  })
}
