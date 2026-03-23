# POLICY SPLIT INTO 3 PARTS TO AVOID HITTING THE 6,144 CHARACTER LIMIT FOR AWS IAM POLICIES

resource "aws_iam_role_policy_attachment" "github_actions_dev_test_pre-prod_prod_1" {
  count      = local.is_dev_test_pre-prod_prod ? 1 : 0
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_dev_test_pre-prod_prod_1[0].arn
}

resource "aws_iam_policy" "github_actions_dev_test_pre-prod_prod_1" {
  count = local.is_dev_test_pre-prod_prod ? 1 : 0
  name  = "${terraform.workspace}-github-actions-policy-dev_test_pre-prod_prod_1"
  path  = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "acm:RequestCertificate",
          "apigateway:DELETE",
          "apigateway:PATCH",
          "apigateway:POST",
          "apigateway:PUT",
          "apigateway:SetWebACL",
          "appconfig:CreateApplication",
          "appconfig:CreateConfigurationProfile",
          "appconfig:CreateDeploymentStrategy",
          "appconfig:CreateEnvironment",
          "appconfig:CreateHostedConfigurationVersion",
          "appconfig:DeleteDeploymentStrategy",
          "appconfig:DeleteHostedConfigurationVersion",
          "appconfig:StartDeployment",
          "appconfig:TagResource",
          "application-autoscaling:DeleteScalingPolicy",
          "application-autoscaling:DeregisterScalableTarget",
          "application-autoscaling:ListTagsForResource",
          "application-autoscaling:PutScalingPolicy",
          "application-autoscaling:RegisterScalableTarget",
          "application-autoscaling:TagResource",
          "application-autoscaling:UntagResource",
          "backup-storage:MountCapsule",
          "backup:CreateBackupPlan",
          "backup:CreateBackupSelection",
          "backup:CreateBackupVault",
          "backup:DeleteBackupSelection",
          "backup:DeleteBackupVault",
          "backup:DeleteRecoveryPoint",
          "backup:DescribeBackupVault",
          "backup:ListTags",
          "backup:UpdateBackupPlan",
          "cloudwatch:DeleteAlarms",
          "cloudwatch:ListTagsForResource",
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:TagResource",
          "cloudwatch:UntagResource",
          "dynamodb:CreateTable",
          "dynamodb:DeleteItem",
          "dynamodb:DeleteTable",
          "dynamodb:DescribeContinuousBackups",
          "dynamodb:DescribeTable",
          "dynamodb:DescribeTimeToLive",
          "dynamodb:GetItem",
          "dynamodb:ListTagsOfResource",
          "dynamodb:PutItem",
          "dynamodb:TagResource",
          "dynamodb:UpdateContinuousBackups",
          "dynamodb:UpdateTable",
          "dynamodb:UpdateTimeToLive",
          "ec2:AllocateAddress",
          "ec2:AssociateRouteTable",
          "ec2:AttachInternetGateway",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateDefaultVpc",
          "ec2:CreateInternetGateway",
          "ec2:CreateNatGateway",
          "ec2:CreateRoute",
          "ec2:CreateRouteTable",
          "ec2:CreateSecurityGroup",
          "ec2:CreateSubnet",
          "ec2:CreateTags",
          "ec2:CreateVpc",
          "ec2:CreateVpcEndpoint",
          "ec2:DeleteInternetGateway",
          "ec2:DeleteRoute",
          "ec2:DeleteRouteTable",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteSubnet",
          "ec2:DeleteVpc",
          "ec2:DeleteVpcEndpoints",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInternetGateways",
          "ec2:DescribePrefixLists",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroupRules",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcEndpoints",
          "ec2:DescribeVpcs",
          "ec2:DetachInternetGateway",
          "ec2:DisassociateAddress",
          "ec2:DisassociateRouteTable",
          "ec2:ModifyVpcAttribute",
          "ec2:ModifyVpcEndpoint",
          "ec2:ReleaseAddress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "github_actions_dev_test_pre-prod_prod_2" {
  count      = local.is_dev_test_pre-prod_prod ? 1 : 0
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_dev_test_pre-prod_prod_2[0].arn
}

resource "aws_iam_policy" "github_actions_dev_test_pre-prod_prod_2" {
  count = local.is_dev_test_pre-prod_prod ? 1 : 0
  name  = "${terraform.workspace}-github-actions-policy-dev_test_pre-prod_prod_2"
  path  = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:CreateRepository",
          "ecr:DeleteLifecyclePolicy",
          "ecr:DeleteRepository",
          "ecr:DeleteRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:GetAuthorizationToken",
          "ecr:GetLifecyclePolicy",
          "ecr:GetRepositoryPolicy",
          "ecr:ListTagsForResource",
          "ecr:PutLifecyclePolicy",
          "ecr:SetRepositoryPolicy",
          "ecr:TagResource",
          "ecs:CreateCluster",
          "ecs:CreateService",
          "ecs:DeleteCluster",
          "ecs:DeleteService",
          "ecs:DeregisterTaskDefinition",
          "ecs:DescribeClusters",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:PutClusterCapacityProviders",
          "ecs:RegisterTaskDefinition",
          "ecs:TagResource",
          "ecs:UntagResource",
          "ecs:UpdateService",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTags",
          "elasticloadbalancing:DescribeTargetGroupAttributes",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyListenerAttributes",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "elasticloadbalancing:SetSecurityGroups",
          "elasticloadbalancing:SetWebACL",
          "events:DeleteRule",
          "events:PutRule",
          "events:PutTargets",
          "events:RemoveTargets",
          "iam:AttachRolePolicy",
          "iam:CreatePolicy",
          "iam:CreatePolicyVersion",
          "iam:CreateRole",
          "iam:CreateServiceLinkedRole",
          "iam:DeletePolicy",
          "iam:DeletePolicyVersion",
          "iam:DeleteRole",
          "iam:DeleteRolePolicy",
          "iam:DetachRolePolicy",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:ListRolePolicies",
          "iam:PassRole",
          "iam:PutRolePolicy",
          "iam:UpdateAssumeRolePolicy",
          "iam:UpdateRoleDescription",
          "kms:CreateAlias",
          "kms:CreateKey",
          "kms:DeleteAlias",
          "kms:DescribeKey",
          "kms:EnableKeyRotation",
          "kms:GetKeyPolicy",
          "kms:GetKeyRotationStatus",
          "kms:ListAliases",
          "kms:ListKeys",
          "kms:ListResourceTags",
          "kms:PutKeyPolicy",
          "kms:RetireGrant",
          "kms:ScheduleKeyDeletion",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:UpdateAlias",
          "kms:UpdateKeyDescription",
          "lambda:AddLayerVersionPermission",
          "lambda:AddPermission",
          "lambda:CreateEventSourceMapping",
          "lambda:CreateFunction",
          "lambda:DeleteEventSourceMapping",
          "lambda:DeleteFunction",
          "lambda:DeleteLayerVersion",
          "lambda:EnableReplication",
          "lambda:GetLayerVersion",
          "lambda:GetLayerVersionPolicy",
          "lambda:GetPolicy",
          "lambda:ListLayerVersions",
          "lambda:ListLayers",
          "lambda:PublishLayerVersion",
          "lambda:PublishVersion",
          "lambda:PutFunctionConcurrency",
          "lambda:RemoveLayerVersionPermission",
          "lambda:RemovePermission",
          "lambda:UpdateEventSourceMapping",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "logs:CreateLogDelivery",
          "logs:CreateLogGroup",
          "logs:DeleteLogDelivery",
          "logs:DeleteLogGroup",
          "logs:DeleteMetricFilter",
          "logs:DescribeLogGroups",
          "logs:DescribeResourcePolicies",
          "logs:GetLogDelivery",
          "logs:ListLogDeliveries",
          "logs:ListTagsLogGroup",
          "logs:PutMetricFilter",
          "logs:UpdateLogDelivery",
          "resource-groups:CreateGroup",
          "resource-groups:ListGroups",
          "resource-groups:SearchResources",
          "route53:AssociateVPCWithHostedZone",
          "route53:ChangeResourceRecordSets",
          "route53:GetChange",
          "route53:GetHostedZone",
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "github_actions_dev_test_pre-prod_prod_3" {
  count      = local.is_dev_test_pre-prod_prod ? 1 : 0
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_dev_test_pre-prod_prod_3[0].arn
}

resource "aws_iam_policy" "github_actions_dev_test_pre-prod_prod_3" {
  count = local.is_dev_test_pre-prod_prod ? 1 : 0
  name  = "${terraform.workspace}-github-actions-policy-dev_test_pre-prod_prod_3"
  path  = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [

          "scheduler:CreateSchedule",
          "scheduler:DeleteSchedule",
          "scheduler:UpdateSchedule",
          "secretsmanager:DeleteSecret",
          "ses:CreateConfigurationSet",
          "ses:CreateConfigurationSetEventDestination",
          "ses:DeleteConfigurationSet",
          "ses:DeleteConfigurationSetEventDestination",
          "ses:DeleteIdentity",
          "ses:DescribeConfigurationSet",
          "ses:ListConfigurationSets",
          "ses:SetIdentityMailFromDomain",
          "ses:UpdateConfigurationSetEventDestination",
          "ses:VerifyDomainDkim",
          "ses:VerifyDomainIdentity",
          "sns:CreateTopic",
          "sns:DeleteTopic",
          "sns:SetTopicAttributes",
          "sns:Subscribe",
          "sns:Unsubscribe",
          "sqs:DeleteMessage",
          "sqs:DeleteQueue",
          "sqs:ListQueues",
          "sqs:createqueue",
          "sqs:setqueueattributes",
          "ssm:AddTagsToResource",
          "ssm:DeleteParameter",
          "ssm:PutParameter",
          "wafv2:AssociateWebACL",
          "wafv2:CreateRegexPatternSet",
          "wafv2:CreateWebACL",
          "wafv2:DeleteRegexPatternSet",
          "wafv2:DeleteWebACL",
          "wafv2:TagResource",
          "wafv2:UpdateWebACL"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "backup:TagResource",
          "backup:UntagResource",
          "cognito-identity:TagResource",
          "cognito-identity:UntagResource",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags",
          "events:TagResource",
          "events:UntagResource",
          "iam:TagInstanceProfile",
          "iam:TagPolicy",
          "iam:TagRole",
          "iam:UntagInstanceProfile",
          "iam:UntagPolicy",
          "iam:UntagRole",
          "lambda:TagResource",
          "lambda:UntagResource",
          "logs:TagResource",
          "logs:UntagResource",
          "resource-groups:DeleteGroup",
          "resource-groups:GetGroup",
          "resource-groups:GetGroupConfiguration",
          "resource-groups:GetGroupQuery",
          "resource-groups:GetTags",
          "resource-groups:ListGroupResources",
          "resource-groups:Tag",
          "resource-groups:Untag",
          "resource-groups:UpdateGroup",
          "resource-groups:UpdateGroupQuery",
          "sns:TagResource",
          "sns:UntagResource"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:backup-plan:*",
          "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:backup-vault:*",
          "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:framework:*-*",
          "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:legal-hold:*",
          "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:report-plan:*-*",
          "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:restore-testing-plan:*-*",
          "arn:aws:cognito-identity:*:${data.aws_caller_identity.current.account_id}:identitypool/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener-rule/app/*/*/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener-rule/net/*/*/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/app/*/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/gwy/*/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/net/*/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/app/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/gwy/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/net/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:targetgroup/*/*",
          "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:truststore/*/*",
          "arn:aws:events:*:${data.aws_caller_identity.current.account_id}:event-bus/*",
          "arn:aws:events:*:${data.aws_caller_identity.current.account_id}:rule/*/*",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/*",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/*",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*",
          "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:code-signing-config:*",
          "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:event-source-mapping:*",
          "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:function:*",
          "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:anomaly-detector:*",
          "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:delivery-destination:*",
          "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:delivery-source:*",
          "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:delivery:*",
          "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:destination:*",
          "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:*",
          "arn:aws:resource-groups:*:${data.aws_caller_identity.current.account_id}:group/*",
          "arn:aws:sns:*:${data.aws_caller_identity.current.account_id}:*"
        ]
      },
      {
        Action = [
          "cognito-identity:CreateIdentityPool",
          "cognito-identity:DeleteIdentityPool",
          "cognito-identity:SetIdentityPoolRoles",
          "cognito-identity:UpdateIdentityPool"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:cognito-identity:eu-west-2:${data.aws_caller_identity.current.account_id}:identitypool/*"
      },
      {
        Action = [
          "logs:DeleteLogGroup",
          "logs:DeleteResourcePolicy",
          "logs:DescribeLogGroups"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:eu-west-2:${data.aws_caller_identity.current.account_id}:log-group:*RUMService*"
      },
      {
        Action = [
          "iam:PassRole",
          "rum:CreateAppMonitor",
          "rum:DeleteAppMonitor",
          "rum:GetAppMonitor",
          "rum:ListTagsForResource",
          "rum:TagResource",
          "rum:UntagResource",
          "rum:UpdateAppMonitor"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:rum:eu-west-2:${data.aws_caller_identity.current.account_id}:appmonitor/*"
      },
    ]
  })
}
