# Resources that are common to test, pre-prod and prod environments.

resource "aws_iam_role_policy_attachment" "github_actions_test_pre-prod_prod" {
  count      = local.is_test_pre-prod_prod ? 1 : 0
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_test_pre-prod_prod[0].arn
}

resource "aws_iam_policy" "github_actions_test_pre-prod_prod" {
  count = local.is_test_pre-prod_prod ? 1 : 0
  name  = "${terraform.workspace}-github-actions-policy-test_pre-prod_prod"
  path  = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudformation:CreateResource",
          "cloudfront:CreateCachePolicy",
          "cloudfront:CreateDistribution",
          "cloudfront:CreateInvalidation",
          "cloudfront:CreateOriginAccessControl",
          "cloudfront:CreateOriginRequestPolicy",
          "cloudfront:DeleteCachePolicy",
          "cloudfront:DeleteDistribution",
          "cloudfront:DeleteOriginAccessControl",
          "cloudfront:TagResource",
          "cloudfront:UntagResource",
          "cloudfront:UpdateDistribution",
          "cloudfront:UpdateOriginAccessControl",
          "cloudfront:UpdateOriginRequestPolicy",
          "cognito-idp:AdminAddUserToGroup",
          "cognito-idp:AdminCreateUser",
          "cognito-idp:CreateGroup",
          "cognito-idp:CreateUserPool",
          "cognito-idp:CreateUserPoolClient",
          "cognito-idp:DeleteUserPool",
          "cognito-idp:SetUserPoolMfaConfig",
          "cognito-idp:TagResource",
          "iam:AddRoleToInstanceProfile",
          "iam:CreateInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:TagRole",
          "lambda:DeleteFunctionConcurrency",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "ssm:CreateDocument"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
