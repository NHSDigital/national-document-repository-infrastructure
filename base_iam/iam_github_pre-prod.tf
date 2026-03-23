resource "aws_iam_role_policy_attachment" "github_actions_pre-prod" {
  count      = local.is_pre-prod ? 1 : 0
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_pre-prod[0].arn
}

resource "aws_iam_policy" "github_actions_pre-prod" {
  count = local.is_pre-prod ? 1 : 0
  name  = "${terraform.workspace}-github-actions-policy-pre-prod"
  path  = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:GenerateDataKey",
          "sqs:sendmessage"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
