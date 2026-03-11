resource "aws_iam_role_policy_attachment" "github_actions_policy_prod" {
  count      = local.is_prod ? 1 : 0
  role       = aws_iam_role.dev_github_actions.name
  policy_arn = aws_iam_policy.github_actions_policy_prod[0].arn
}

resource "aws_iam_policy" "github_actions_policy_prod" {
  count = local.is_prod ? 1 : 0
  name  = "github-actions-policy-prod"
  path  = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
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
          "arn:aws:ecr:eu-west-2:${data.aws_caller_identity.current.account_id}:repository/ndr-prod-app",
          "arn:aws:ecr:eu-west-2:${data.aws_caller_identity.current.account_id}:repository/prod-data-collection"
        ]
      },
    ]
  })
}
