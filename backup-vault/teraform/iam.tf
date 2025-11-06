resource "aws_iam_policy" "administrator_permission_restrictions" {
  name = "AdministratorRestriction"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Deny",
        Action = [
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:PutLifecycleConfiguration",
          "s3:PutObject",
          "s3:RestoreObject"
        ],
        Resource = [
          "arn:aws:s3:::*/*.tfstate"
        ]
      }
    ]
  })
  tags = {
    Name      = "AdministratorRestriction"
    Workspace = "core"
  }
}
