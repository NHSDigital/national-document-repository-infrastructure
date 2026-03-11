resource "aws_iam_role_policy_attachment" "github_actions_policy_test" {
  count      = local.is_test ? 1 : 0
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_policy_test[0].arn
}

resource "aws_iam_policy" "github_actions_policy_test" {
  count = local.is_test ? 1 : 0
  name  = "github-actions-policy-test"
  path  = "/"
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
          "*",
          "arn:aws:backup:*:694282683086:backup-plan:*",
          "arn:aws:backup:*:694282683086:backup-vault:*",
          "arn:aws:backup:*:694282683086:framework:*-*",
          "arn:aws:backup:*:694282683086:legal-hold:*",
          "arn:aws:backup:*:694282683086:report-plan:*-*",
          "arn:aws:backup:*:694282683086:restore-testing-plan:*-*",
          "arn:aws:cognito-identity:*:694282683086:identitypool/*",
          "arn:aws:elasticloadbalancing:*:694282683086:listener-rule/app/*/*/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:listener-rule/net/*/*/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:listener/app/*/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:listener/gwy/*/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:listener/net/*/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/app/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/gwy/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/net/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:targetgroup/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:truststore/*/*",
          "arn:aws:events:*:694282683086:event-bus/*",
          "arn:aws:events:*:694282683086:rule/*/*",
          "arn:aws:iam::694282683086:instance-profile/*",
          "arn:aws:iam::694282683086:policy/*",
          "arn:aws:iam::694282683086:role/*",
          "arn:aws:lambda:*:694282683086:code-signing-config:*",
          "arn:aws:lambda:*:694282683086:event-source-mapping:*",
          "arn:aws:lambda:*:694282683086:function:*",
          "arn:aws:logs:*:694282683086:anomaly-detector:*",
          "arn:aws:logs:*:694282683086:delivery-destination:*",
          "arn:aws:logs:*:694282683086:delivery-source:*",
          "arn:aws:logs:*:694282683086:delivery:*",
          "arn:aws:logs:*:694282683086:destination:*",
          "arn:aws:logs:*:694282683086:log-group:*",
          "arn:aws:resource-groups:*:694282683086:group/*",
          "arn:aws:sns:*:694282683086:*"
        ]
      },
      {
        Action = [
          "acm:AddTagsToCertificate",
          "acm:DeleteCertificate",
          "acm:DescribeCertificate",
          "apigateway:AddCertificateToDomain",
          "apigateway:GET",
          "apigateway:RemoveCertificateFromDomain",
          "backup:ListRecoveryPointsByBackupVault",
          "cloudformation:DeleteResource",
          "cloudfront:DeleteOriginRequestPolicy",
          "cloudfront:GetOriginAccessControl",
          "cognito-idp:AdminDeleteUser",
          "cognito-idp:AdminRemoveUserFromGroup",
          "cognito-idp:DeleteGroup",
          "cognito-idp:DeleteUserPoolClient",
          "ec2:DeleteNetworkInterface",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "events:TagResource",
          "iam:ListRoles",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:TagPolicy",
          "kms:CreateGrant",
          "kms:Decrypt",
          "kms:Encrypt",
          "lambda:GetFunction",
          "lambda:GetFunctionConfiguration",
          "resource-groups:DeleteGroup",
          "scheduler:TagResource",
          "scheduler:UntagResource",
          "sns:TagResource",
          "ssm:DeleteDocument"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags",
          "events:TagResource",
          "events:UntagResource"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:elasticloadbalancing:*:694282683086:listener-rule/app/*/*/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:listener-rule/net/*/*/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:listener/app/*/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:listener/gwy/*/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:listener/net/*/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/app/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/gwy/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/net/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:targetgroup/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:truststore/*/*",
          "arn:aws:events:*:694282683086:rule/*"
        ]
      },
      {
        Action = [
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:elasticloadbalancing:*:694282683086:listener-rule/app/*/*/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:listener-rule/net/*/*/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:listener/app/*/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:listener/gwy/*/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:listener/net/*/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/app/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/gwy/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/net/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:targetgroup/*/*",
          "arn:aws:elasticloadbalancing:*:694282683086:truststore/*/*"
        ]
      },
    ]
  })
}
