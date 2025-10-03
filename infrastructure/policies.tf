resource "aws_iam_policy" "ssm_access_policy" {
  name = "${terraform.workspace}_ssm_parameters"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:PutParameter"
        ],
        Resource = [
          "arn:aws:ssm:*:*:parameter/*",
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "read_only_role_extra_permissions" {
  count = local.is_sandbox ? 0 : 1
  name  = "ReadOnlyExtraAccess"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt",
        ],
        Resource = [
          "arn:aws:kms:eu-west-2:${data.aws_caller_identity.current.account_id}:key/*",
        ]
      }
    ]
  })
  tags = {
    Name      = "ReadOnlyExtraAccess"
    Workspace = "core"
  }
}
