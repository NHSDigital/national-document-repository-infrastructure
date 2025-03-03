locals {
  cognito_role_name = "${terraform.workspace}-cognito-unauth-role"
  rum_role_name     = "${terraform.workspace}-rum-service-role"
}

resource "aws_iam_role" "cloudwatch_rum" {
  name = local.rum_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "rum.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "cognito_unauthenticated" {
  name = local.cognito_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal : {
          Federated : "cognito-identity.amazonaws.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.cloudwatch_rum[0].id
          },
          "ForAnyValue:StringLike" = {
            "cognito-identity.amazonaws.com:amr" = "unauthenticated"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_rum_cognito_access" {
  name        = "${terraform.workspace}-cloudwatch-rum-cognito-access-policy"
  description = "Policy for unauthenticated Cognito identities"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "rum:PutRumEvents",
          "Resource" : "arn:aws:rum:${local.current_region}:${local.current_account_id}:appmonitor/${aws_rum_app_monitor.this.id}"
        }
      ]
  })
}

resource "aws_iam_policy" "cloudwatch_rum_management" {
  name        = "${terraform.workspace}-cloudwatch-rum-management-policy"
  description = "Policy to manage RUM app monitors and associated logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "rum:CreateAppMonitor",
          "rum:DescribeAppMonitor",
          "rum:DeleteAppMonitor",
          "rum:UpdateAppMonitor",
          "rum:TagResource",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "iam:PassRole"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_rum_cognito_unauth" {
  role       = aws_iam_role.cognito_unauthenticated.name
  policy_arn = aws_iam_policy.cloudwatch_rum_cognito_access.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_rum_management" {
  role       = aws_iam_role.cloudwatch_rum.name
  policy_arn = aws_iam_policy.cloudwatch_rum_management.arn
}

resource "aws_cognito_identity_pool_roles_attachment" "cloudwatch_rum" {
  count            = local.is_production ? 0 : 1
  identity_pool_id = aws_cognito_identity_pool.cloudwatch_rum[0].id

  roles = {
    unauthenticated = aws_iam_role.cognito_unauthenticated.arn
  }
}

resource "aws_cognito_identity_pool" "cloudwatch_rum" {
  count                            = local.is_production ? 0 : 1
  identity_pool_name               = "${terraform.workspace}-cloudwatch-rum-identity-pool"
  allow_unauthenticated_identities = true
}

resource "aws_rum_app_monitor" "this" {
  count          = local.is_production ? 0 : 1
  name           = "${terraform.workspace}-app-monitor"
  domain         = "*.patient-deductions.nhs.uk"
  cw_log_enabled = false

  app_monitor_configuration {
    identity_pool_id    = aws_cognito_identity_pool.cloudwatch_rum[0].id
    allow_cookies       = true
    enable_xray         = true
    session_sample_rate = 1.0
    telemetries         = ["errors", "performance", "http"]
  }

  tags = {
    ServiceRole = aws_iam_role.cloudwatch_rum.arn
  }
}
