resource "aws_iam_role_policy_attachment" "github_actions_test" {
  count      = local.is_test ? 1 : 0
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_test[0].arn
}

resource "aws_iam_policy" "github_actions_test" {
  count = local.is_test ? 1 : 0
  name  = "${terraform.workspace}-github-actions-policy-test"
  path  = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
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
    ]
  })
}
