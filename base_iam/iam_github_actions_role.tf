resource "aws_iam_role" "github_actions" {
  name                  = "${terraform.workspace}-github-actions-role"
  description           = "This role provides access for GitHub Actions to the ${terraform.workspace} environment. "
  force_detach_policies = false
  max_session_duration  = 3600
  name_prefix           = null
  path                  = "/"
  permissions_boundary  = null
  tags                  = {}
  assume_role_policy = local.is_sandbox_or_dev ? jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRoleWithWebIdentity"
          Condition = {
            StringEquals = {
              "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            }
            StringLike = {
              "token.actions.githubusercontent.com:sub" = [
                "repo:NHSDigital/national-document-repository-infrastructure:*",
                "repo:NHSDigital/national-document-repository:*",
              ]
            }
          }
          Effect = "Allow"
          Principal = {
            Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
          }
        },
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/eu-west-2/AWSReservedSSO_DomainCGpit-Administrators_e00623801cb4b59e"
          }
        },
      ]
      Version = "2012-10-17"
    }
    ) : jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRoleWithWebIdentity"
          Condition = {
            StringEquals = {
              "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            }
            StringLike = {
              "token.actions.githubusercontent.com:sub" = [
                "repo:NHSDigital/national-document-repository-infrastructure:*",
                "repo:NHSDigital/national-document-repository:*",
              ]
            }
          }
          Effect = "Allow"
          Principal = {
            Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
}
