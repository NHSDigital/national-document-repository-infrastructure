resource "aws_iam_role_policy_attachment" "github_actions_policy_pre-prod_prod" {
count      = local.is_pre-prod_prod ? 1 : 0
role       = aws_iam_role.dev_github_actions.name
policy_arn = aws_iam_policy.github_actions_policy_pre-prod_prod[0].arn
}

resource "aws_iam_policy" "github_actions_policy_pre-prod_prod" {
  count = local.is_pre-prod_prod ? 1 : 0
  name   = "github-actions-policy-pre-prod_prod"
  path   = "/"
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
        Effect = "Allow"
        Resource = "*"
      },
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
          "iam:TagInstanceProfile",
          "iam:TagPolicy",
          "iam:TagRole",
          "iam:UntagInstanceProfile",
          "iam:UntagPolicy",
          "iam:UntagRole",
          "lambda:TagResource",
          "lambda:UntagResource",
          "logs:TagResource",
          "logs:UntagResource",
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
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/*",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/*",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*",
          "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:code-signing-config:*",
          "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:event-source-mapping:*",
          "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:function:*",
          "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:anomaly-detector:*",
          "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:delivery-destination:*",
          "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:delivery-source:*",
          "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:delivery:*",
          "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:destination:*",
          "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:*",
          "arn:aws:resource-groups:*:${data.aws_caller_identity.current.account_id}:group/*",
          "arn:aws:sns:*:${data.aws_caller_identity.current.account_id}:*"
        ]
      },
      {
        Action = [
          "states:CreateStateMachine",
          "states:DeleteStateMachine",
          "states:DescribeStateMachine",
          "states:TagResource",
          "states:UntagResource",
          "states:UpdateStateMachine"
        ]
        Effect = "Allow"
        Resource = "arn:aws:states:eu-west-2:${data.aws_caller_identity.current.account_id}:stateMachine:*"
      },
      {
        Action = [
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener-rule/app/*/*/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener-rule/net/*/*/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/app/*/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/gwy/*/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/net/*/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/app/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/gwy/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/net/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:targetgroup/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:truststore/*/*"
        ]
      },
    ]
  })
}
