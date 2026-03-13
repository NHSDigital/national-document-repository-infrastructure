resource "aws_iam_role_policy_attachment" "github_actions_policy_pre-prod" {
  count      = local.is_pre-prod ? 1 : 0
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_policy_pre-prod[0].arn
}

resource "aws_iam_policy" "github_actions_policy_pre-prod" {
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
          "arn:aws:ecr:eu-west-2:${data.aws_caller_identity.current.account_id}:repository/ndr-pre-prod-app",
          "arn:aws:ecr:eu-west-2:${data.aws_caller_identity.current.account_id}:repository/pre-prod-data-collection"
        ]
      },
    ]
  })
}
