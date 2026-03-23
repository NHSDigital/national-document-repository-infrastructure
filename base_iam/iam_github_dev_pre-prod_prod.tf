resource "aws_iam_role_policy_attachment" "github_actions_dev_pre-prod_prod" {
  count      = local.is_dev_pre-prod_prod ? 1 : 0
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_dev_pre-prod_prod[0].arn
}

resource "aws_iam_policy" "github_actions_dev_pre-prod_prod" {
  count = local.is_dev_pre-prod_prod ? 1 : 0
  name  = "${terraform.workspace}-github-actions-policy-dev_pre-prod_prod"
  path  = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "acm:ListCertificates",
          "ecs:UpdateCluster",
          "logs:PutRetentionPolicy"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "acm:AddTagsToCertificate",
          "acm:DeleteCertificate",
          "acm:DescribeCertificate",
          "acm:GetCertificate",
          "acm:ListTagsForCertificate",
          "apigateway:AddCertificateToDomain",
          "apigateway:RemoveCertificateFromDomain",
          "route53:ChangeResourceRecordSets",
          "route53:GetHostedZone"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:acm:eu-west-2:${data.aws_caller_identity.current.account_id}:certificate/*",
          "arn:aws:apigateway:eu-west-2::/domainnames",
          "arn:aws:apigateway:eu-west-2::/domainnames/*",
          "arn:aws:route53:::hostedzone/*"
        ]
      },
      {
        Action = [
          "acm:AddTagsToCertificate",
          "acm:DeleteCertificate"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:acm:us-east-1:${data.aws_caller_identity.current.account_id}:certificate/*"
      },
      {
        Action   = "apigateway:AddCertificateToDomain"
        Effect   = "Allow"
        Resource = "arn:aws:apigateway:eu-west-2::/domainnames"
      },
      {
        Action = [
          "apigateway:AddCertificateToDomain",
          "apigateway:RemoveCertificateFromDomain"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:apigateway:eu-west-2::/domainnames",
          "arn:aws:apigateway:eu-west-2::/domainnames/*"
        ]
      },
      {
        Action = [
          "kms:CreateGrant",
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:TagResource",
          "kms:UntagResource",
          "lambda:CreateFunction",
          "lambda:DeleteFunctionConcurrency",
          "lambda:GetFunction",
          "lambda:GetFunctionConfiguration",
          "lambda:InvokeFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "s3:PutObject"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*",
          "arn:aws:lambda:eu-west-2:*:function:*"
        ]
      },
    ]
  })
}
