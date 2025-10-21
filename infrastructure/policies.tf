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

resource "aws_iam_policy" "production_support" {
  count = local.is_production ? 1 : 0
  name  = "ProductionSupport"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AWS Transfer Family",
        Effect = "Allow",
        Action = [
          "transfer:CreateUser"
        ],
        Resource = [
          "arn:aws:transfer:eu-west-2:${data.aws_caller_identity.current.account_id}:*"
        ]
      }
    ]
  })
  tags = {
    Name      = "ProductionSupport"
    Workspace = "core"
  }
}
