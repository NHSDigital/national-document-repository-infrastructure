resource "aws_iam_role_policy_attachment" "github_actions_policy_dev_test" {
count      = local.is_dev_test ? 1 : 0
role       = aws_iam_role.dev_github_actions.name
policy_arn = aws_iam_policy.github_actions_policy_dev_test[0].arn
}

resource "aws_iam_policy" "github_actions_policy_dev_test" {
  count = local.is_dev_test ? 1 : 0
  name   = "github-actions-policy-dev_test"
  path   = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "appconfig:CreateExtension",
          "appconfig:CreateExtensionAssociation",
          "appconfig:DeleteApplication",
          "appconfig:DeleteConfigurationProfile",
          "appconfig:DeleteEnvironment",
          "appconfig:GetApplication",
          "appconfig:GetConfiguration",
          "appconfig:GetConfigurationProfile",
          "appconfig:GetDeployment",
          "appconfig:GetDeploymentStrategy",
          "appconfig:GetEnvironment",
          "appconfig:GetExtension",
          "appconfig:GetExtensionAssociation",
          "appconfig:GetHostedConfigurationVersion",
          "appconfig:GetLatestConfiguration",
          "appconfig:ListApplications",
          "appconfig:ListConfigurationProfiles",
          "appconfig:ListDeploymentStrategies",
          "appconfig:ListDeployments",
          "appconfig:ListEnvironments",
          "appconfig:ListExtensionAssociations",
          "appconfig:ListExtensions",
          "appconfig:ListHostedConfigurationVersions",
          "appconfig:ListTagsForResource",
          "appconfig:StopDeployment",
          "appconfig:UntagResource",
          "appconfig:UpdateApplication",
          "appconfig:UpdateConfigurationProfile",
          "appconfig:UpdateDeploymentStrategy",
          "appconfig:UpdateEnvironment",
          "backup:DeleteBackupPlan",
          "backup:GetBackupPlan",
          "backup:GetBackupSelection",
          "ec2:DeleteNatGateway",
          "s3:*",
          "sqs:TagQueue",
          "states:CreateStateMachine",
          "states:DeleteStateMachine",
          "states:DescribeStateMachine",
          "states:TagResource",
          "states:UntagResource",
          "states:UpdateStateMachine"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:AssociateKmsKey",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DeleteResourcePolicy",
          "logs:DeleteRetentionPolicy",
          "logs:DescribeLogGroups",
          "logs:DisassociateKmsKey",
          "logs:PutLogEvents",
          "logs:PutResourcePolicy",
          "logs:PutRetentionPolicy",
          "logs:TagResource",
          "logs:UntagResource"
        ]
        Effect = "Allow"
        Resource = "arn:aws:logs:eu-west-2:${data.aws_caller_identity.current.account_id}:log-group:*"
      },
      {
        Action = "servicequotas:RequestServiceQuotaIncrease"
        Effect = "Allow"
        Resource = [
          "arn:aws:servicequotas::${data.aws_caller_identity.current.account_id}:iam/L-E95E4862",
          "arn:aws:servicequotas::${data.aws_caller_identity.current.account_id}:iam/L-FE177D64",
          "arn:aws:servicequotas:us-east-1:${data.aws_caller_identity.current.account_id}:lambda/L-B99A9384"
        ]
      },
    ]
  })
}
