# aws_iam_role.github_role_dev[0]:
resource "aws_iam_role" "github_role_dev" {
  count = var.environment == "dev" ? 1 : 0
  assume_role_policy = jsonencode(
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
            Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
          }
        },
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::${var.aws_account_id}:role/aws-reserved/sso.amazonaws.com/eu-west-2/AWSReservedSSO_DomainCGpit-Administrators_e00623801cb4b59e"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  description           = "This role is to provide access for GitHub actions to the development environment. "
  force_detach_policies = false
  managed_policy_arns = [
    aws_iam_policy.config_policy_dev[0].arn,
    aws_iam_policy.ecr_github_access_policy_dev[0].arn,
    aws_iam_policy.github_actions_terraform_full_dev[0].arn,
    aws_iam_policy.github_mtls_gateway_dev[0].arn,
    aws_iam_policy.github_terraform_tagging_policy_dev[0].arn,
    aws_iam_policy.lambda_github_access_policy_dev[0].arn,
    aws_iam_policy.repo_app_config_dev[0].arn,
    aws_iam_policy.terraform_github_dynamodb_access_policy_dev[0].arn,
    aws_iam_policy.terraform_github_s3_access_policy_dev[0].arn,
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
  ]
  max_session_duration = 3600
  name                 = "github-actions-dev-role"
  name_prefix          = null
  path                 = "/"
  permissions_boundary = null
  tags                 = {}
  tags_all             = {}

  inline_policy {
    name = "cloudtrail"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "cloudtrail:AddTags",
              "cloudtrail:CreateTrail",
              "cloudtrail:StartLogging",
              "cloudtrail:DeleteTrail",
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:cloudtrail:eu-west-2:${var.aws_account_id}:trail/*",
              "arn:aws:cloudtrail:eu-west-2:${var.aws_account_id}:eventdatastore/*",
              "arn:aws:cloudtrail:eu-west-2:${var.aws_account_id}:channel/*",
            ]
            Sid = "VisualEditor0"
          },
          {
            Action   = "organizations:ListAWSServiceAccessForOrganization"
            Effect   = "Allow"
            Resource = "*"
            Sid      = "VisualEditor1"
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
  inline_policy {
    name = "cloudwatch_logs_policy"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "logs:DescribeLogGroups",
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents",
              "logs:PutRetentionPolicy",
              "logs:PutResourcePolicy",
              "logs:DeleteResourcePolicy",
              "logs:DeleteRetentionPolicy",
              "logs:TagResource",
              "logs:UntagResource",
              "logs:AssociateKmsKey",
              "logs:DisassociateKmsKey",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:logs:eu-west-2:${var.aws_account_id}:log-group:*"
            Sid      = "Statement1"
          },
          {
            Action = [
              "logs:PutDeliverySource",
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:logs:us-east-1:${var.aws_account_id}:delivery-source:*",
            ]
            Sid = "Statement2"
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
  inline_policy {
    name = "ecs_policy"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "ecs:UpdateCluster",
              "ecs:PutClusterCapacityProviders",
            ]
            Effect   = "Allow"
            Resource = "*"
            Sid      = "VisualEditor0"
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
  inline_policy {
    name = "github-actions-waf-override"
    policy = jsonencode(
      {
        Statement = [
          {
            Action   = "apigateway:SetWebACL"
            Effect   = "Allow"
            Resource = "arn:aws:apigateway:eu-west-2::/restapis/*/stages/*"
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
  inline_policy {
    name = "lambda_layer_policy"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "lambda:GetLayerVersion",
              "lambda:PublishLayerVersion",
              "lambda:DeleteLayerVersion",
              "lambda:ListLayerVersions",
              "lambda:ListLayers",
              "lambda:AddLayerVersionPermission",
              "lambda:GetLayerVersionPolicy",
              "lambda:RemoveLayerVersionPermission",
            ]
            Effect   = "Allow"
            Resource = "*"
            Sid      = "VisualEditor0"
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
  inline_policy {
    name = "rum_policy"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "cognito-identity:SetIdentityPoolRoles",
              "cognito-identity:CreateIdentityPool",
              "cognito-identity:DeleteIdentityPool",
              "cognito-identity:UpdateIdentityPool",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:cognito-identity:eu-west-2:${var.aws_account_id}:identitypool/*"
            Sid      = "VisualEditor0"
          },
          {
            Action = [
              "rum:TagResource",
              "rum:UntagResource",
              "rum:ListTagsForResource",
              "iam:PassRole",
              "rum:UpdateAppMonitor",
              "rum:GetAppMonitor",
              "rum:CreateAppMonitor",
              "rum:DeleteAppMonitor",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:rum:eu-west-2:${var.aws_account_id}:appmonitor/*"
            Sid      = "VisualEditor1"
          },
          {
            Action = [
              "logs:DeleteLogGroup",
              "logs:DeleteResourcePolicy",
              "logs:DescribeLogGroups",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:logs:eu-west-2:${var.aws_account_id}:log-group:*RUMService*"
            Sid      = "VisualEditor2"
          },
          {
            Action = [
              "logs:CreateLogDelivery",
              "logs:GetLogDelivery",
              "logs:UpdateLogDelivery",
              "logs:DeleteLogDelivery",
              "logs:ListLogDeliveries",
              "logs:DescribeResourcePolicies",
            ]
            Effect   = "Allow"
            Resource = "*"
            Sid      = "VisualEditor3"
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
  inline_policy {
    name = "step-functions"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "states:DescribeStateMachine",
              "states:UpdateStateMachine",
              "states:DeleteStateMachine",
              "states:CreateStateMachine",
              "states:TagResource",
              "states:UntagResource",
            ]
            Effect   = "Allow"
            Resource = "*"
            Sid      = "VisualEditor0"
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
}


# aws_iam_policy.config_policy_dev[0]:
resource "aws_iam_policy" "config_policy_dev" {
  count       = var.environment == "dev" ? 1 : 0
  description = null
  name        = "config-policy"
  name_prefix = null
  path        = "/"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "config:DeleteDeliveryChannel",
            "config:PutConfigurationRecorder",
            "config:StopConfigurationRecorder",
            "config:StartConfigurationRecorder",
            "config:PutDeliveryChannel",
            "config:DeleteConfigurationRecorder",
            "config:DescribeConfigurationRecorderStatus",
          ]
          Effect   = "Allow"
          Resource = "*"
          Sid      = "VisualEditor0"
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags     = {}
  tags_all = {}
}


# aws_iam_policy.ecr_github_access_policy_dev[0]:
resource "aws_iam_policy" "ecr_github_access_policy_dev" {
  count       = var.environment == "dev" ? 1 : 0
  description = null
  name        = "ecr-github-access-policy"
  name_prefix = null
  path        = "/"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:CompleteLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:InitiateLayerUpload",
            "ecr:BatchCheckLayerAvailability",
            "ecr:PutImage",
          ]
          Effect   = "Allow"
          Resource = "arn:aws:ecr:eu-west-2:*:repository/*"
          Sid      = "VisualEditor0"
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags     = {}
  tags_all = {}
}


# aws_iam_policy.github_actions_terraform_full_dev[0]:
resource "aws_iam_policy" "github_actions_terraform_full_dev" {
  count       = var.environment == "dev" ? 1 : 0
  description = "All permissions required for Terraform to do its thing."
  name        = "github_actions_terraform_full"
  name_prefix = null
  path        = "/"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:DeleteVpcEndpoints",
            "ec2:AttachInternetGateway",
            "iam:PutRolePolicy",
            "ecr:DeleteRepository",
            "scheduler:DeleteSchedule",
            "ec2:CreateRoute",
            "cloudwatch:ListTagsForResource",
            "ecr:TagResource",
            "dynamodb:DescribeContinuousBackups",
            "events:RemoveTargets",
            "lambda:DeleteFunction",
            "iam:ListRolePolicies",
            "ecs:TagResource",
            "ecr:GetLifecyclePolicy",
            "iam:GetRole",
            "dynamodb:BatchWriteItem",
            "elasticloadbalancing:CreateTargetGroup",
            "ecr:GetAuthorizationToken",
            "application-autoscaling:DeleteScalingPolicy",
            "kms:RetireGrant",
            "elasticloadbalancing:AddTags",
            "ec2:DeleteNatGateway",
            "lambda:PublishVersion",
            "apigateway:POST",
            "lambda:DeleteEventSourceMapping",
            "elasticloadbalancing:ModifyLoadBalancerAttributes",
            "dynamodb:UpdateTable",
            "ec2:ModifyVpcEndpoint",
            "logs:ListTagsLogGroup",
            "kms:PutKeyPolicy",
            "events:PutRule",
            "ec2:CreateVpc",
            "dynamodb:ListTagsOfResource",
            "iam:PassRole",
            "logs:DeleteMetricFilter",
            "sqs:createqueue",
            "iam:DeleteRolePolicy",
            "application-autoscaling:TagResource",
            "ec2:ReleaseAddress",
            "lambda:UpdateEventSourceMapping",
            "elasticloadbalancing:CreateLoadBalancer",
            "apigateway:PUT",
            "route53:ListTagsForResource",
            "ec2:DescribeSecurityGroups",
            "iam:CreatePolicy",
            "sqs:TagQueue",
            "iam:CreateServiceLinkedRole",
            "kms:CreateAlias",
            "elasticloadbalancing:DescribeTargetGroups",
            "route53:AssociateVPCWithHostedZone",
            "elasticloadbalancing:DeleteListener",
            "iam:UpdateAssumeRolePolicy",
            "iam:GetPolicyVersion",
            "wafv2:AssociateWebACL",
            "ec2:DeleteSubnet",
            "elasticloadbalancing:SetWebACL",
            "ecs:UpdateService",
            "elasticloadbalancing:DescribeLoadBalancers",
            "ssm:DeleteParameter",
            "cloudfront:*",
            "kms:GetKeyRotationStatus",
            "dynamodb:DescribeTable",
            "ssm:AddTagsToResource",
            "ecs:RegisterTaskDefinition",
            "route53:ListResourceRecordSets",
            "ecr:CreateRepository",
            "ecs:DeleteService",
            "application-autoscaling:UntagResource",
            "ec2:DescribePrefixLists",
            "backup:CreateBackupVault",
            "backup:UpdateBackupPlan",
            "sqs:DeleteQueue",
            "ec2:DeleteVpc",
            "kms:DeleteAlias",
            "sns:DeleteTopic",
            "wafv2:DeleteWebACL",
            "dynamodb:DeleteItem",
            "iam:DeletePolicy",
            "sns:SetTopicAttributes",
            "ses:VerifyDomainDkim",
            "lambda:PutFunctionConcurrency",
            "dynamodb:UpdateContinuousBackups",
            "ecs:CreateService",
            "elasticloadbalancing:CreateListener",
            "kms:ScheduleKeyDeletion",
            "ecr:DescribeRepositories",
            "ecs:DescribeServices",
            "iam:CreatePolicyVersion",
            "ecs:UntagResource",
            "sqs:ListQueues",
            "wafv2:UpdateWebACL",
            "dynamodb:DescribeTimeToLive",
            "kms:UpdateAlias",
            "backup:GetBackupSelection",
            "kms:ListKeys",
            "events:PutTargets",
            "lambda:AddPermission",
            "ecr:SetRepositoryPolicy",
            "ec2:DeleteSecurityGroup",
            "application-autoscaling:DeregisterScalableTarget",
            "backup:DeleteBackupPlan",
            "ses:SetIdentityMailFromDomain",
            "lambda:CreateFunction",
            "sqs:DeleteMessage",
            "elasticloadbalancing:ModifyListener",
            "cloudwatch:DeleteAlarms",
            "secretsmanager:DeleteSecret",
            "wafv2:CreateRegexPatternSet",
            "wafv2:CreateWebACL",
            "dynamodb:DeleteTable",
            "ecs:DescribeTaskDefinition",
            "ec2:DeleteRouteTable",
            "ec2:CreateInternetGateway",
            "ec2:RevokeSecurityGroupEgress",
            "sns:Subscribe",
            "ec2:DeleteInternetGateway",
            "wafv2:TagResource",
            "dynamodb:UpdateTimeToLive",
            "iam:GetPolicy",
            "ec2:CreateTags",
            "sns:CreateTopic",
            "ecs:DeleteCluster",
            "iam:UpdateRoleDescription",
            "iam:DeleteRole",
            "ec2:DisassociateRouteTable",
            "backup:GetBackupPlan",
            "wafv2:DeleteRegexPatternSet",
            "dynamodb:CreateTable",
            "ec2:RevokeSecurityGroupIngress",
            "lambda:UpdateFunctionCode",
            "ec2:CreateDefaultVpc",
            "ec2:CreateSubnet",
            "ec2:DescribeSubnets",
            "iam:GetRolePolicy",
            "sqs:setqueueattributes",
            "ec2:DisassociateAddress",
            "kms:UntagResource",
            "ec2:CreateNatGateway",
            "kms:ListResourceTags",
            "ecr:ListTagsForResource",
            "ses:VerifyDomainIdentity",
            "ecs:DeregisterTaskDefinition",
            "apigateway:DELETE",
            "apigateway:SetWebACL",
            "backup:CreateBackupSelection",
            "scheduler:UpdateSchedule",
            "ec2:DescribeAvailabilityZones",
            "kms:CreateKey",
            "kms:EnableKeyRotation",
            "ecr:PutLifecyclePolicy",
            "s3:*",
            "kms:GetKeyPolicy",
            "route53:ListHostedZones",
            "backup:DeleteBackupVault",
            "lambda:UpdateFunctionConfiguration",
            "elasticloadbalancing:DeleteTargetGroup",
            "events:DeleteRule",
            "backup:DescribeBackupVault",
            "ec2:DescribeVpcs",
            "kms:ListAliases",
            "backup:CreateBackupPlan",
            "ses:DeleteIdentity",
            "lambda:RemovePermission",
            "backup:ListTags",
            "route53:GetHostedZone",
            "sns:Unsubscribe",
            "iam:CreateRole",
            "iam:AttachRolePolicy",
            "lambda:EnableReplication",
            "ec2:AssociateRouteTable",
            "elasticloadbalancing:DeleteLoadBalancer",
            "ec2:DescribeInternetGateways",
            "backup:DeleteBackupSelection",
            "iam:DetachRolePolicy",
            "cloudwatch:UntagResource",
            "iam:ListAttachedRolePolicies",
            "dynamodb:GetItem",
            "elasticloadbalancing:ModifyTargetGroupAttributes",
            "ec2:DescribeRouteTables",
            "application-autoscaling:RegisterScalableTarget",
            "dynamodb:PutItem",
            "ecs:CreateCluster",
            "route53:ChangeResourceRecordSets",
            "ec2:CreateRouteTable",
            "ec2:DetachInternetGateway",
            "ecr:DeleteLifecyclePolicy",
            "logs:CreateLogGroup",
            "backup-storage:MountCapsule",
            "ecs:DescribeClusters",
            "ssm:PutParameter",
            "elasticloadbalancing:DescribeLoadBalancerAttributes",
            "logs:CreateLogDelivery",
            "logs:PutMetricFilter",
            "elasticloadbalancing:DescribeTargetGroupAttributes",
            "ec2:DescribeSecurityGroupRules",
            "application-autoscaling:PutScalingPolicy",
            "ec2:DescribeVpcEndpoints",
            "route53:GetChange",
            "ec2:DeleteTags",
            "lambda:GetLayerVersion",
            "lambda:CreateEventSourceMapping",
            "kms:TagResource",
            "elasticloadbalancing:DescribeListeners",
            "dynamodb:TagResource",
            "ec2:CreateSecurityGroup",
            "apigateway:PATCH",
            "kms:DescribeKey",
            "application-autoscaling:ListTagsForResource",
            "ec2:ModifyVpcAttribute",
            "ecr:DeleteRepositoryPolicy",
            "ec2:AuthorizeSecurityGroupEgress",
            "elasticloadbalancing:ModifyListenerAttributes",
            "kms:UpdateKeyDescription",
            "logs:DescribeLogGroups",
            "logs:DeleteLogGroup",
            "elasticloadbalancing:DescribeTags",
            "ec2:DeleteRoute",
            "backup:DeleteRecoveryPoint",
            "ec2:AllocateAddress",
            "cloudwatch:PutMetricAlarm",
            "cloudwatch:TagResource",
            "ec2:CreateVpcEndpoint",
            "elasticloadbalancing:SetSecurityGroups",
            "scheduler:CreateSchedule",
            "logs:PutRetentionPolicy",
            "lambda:GetPolicy",
            "iam:DeletePolicyVersion",
            "ecr:GetRepositoryPolicy",
            "cognito-idp:*",
          ]
          Effect   = "Allow"
          Resource = "*"
          Sid      = "VisualEditor0"
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags     = {}
  tags_all = {}
}


# aws_iam_policy.github_mtls_gateway_dev[0]:
resource "aws_iam_policy" "github_mtls_gateway_dev" {
  count       = var.environment == "dev" ? 1 : 0
  description = null
  name        = "github_mtls_gateway"
  name_prefix = null
  path        = "/"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "acm:RequestCertificate",
            "route53:ListHostedZones",
            "acm:ListCertificates",
          ]
          Effect   = "Allow"
          Resource = "*"
          Sid      = "VisualEditor0"
        },
        {
          Action   = "apigateway:AddCertificateToDomain"
          Effect   = "Allow"
          Resource = "arn:aws:apigateway:eu-west-2::/domainnames"
          Sid      = "VisualEditor1"
        },
        {
          Action = [
            "acm:DeleteCertificate",
            "acm:DescribeCertificate",
            "acm:GetCertificate",
            "route53:GetHostedZone",
            "route53:ChangeResourceRecordSets",
            "apigateway:AddCertificateToDomain",
            "acm:AddTagsToCertificate",
            "apigateway:RemoveCertificateFromDomain",
            "acm:ListTagsForCertificate",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:apigateway:eu-west-2::/domainnames",
            "arn:aws:apigateway:eu-west-2::/domainnames/*",
            "arn:aws:route53:::hostedzone/*",
            "arn:aws:acm:eu-west-2:${var.aws_account_id}:certificate/*",
          ]
          Sid = "VisualEditor2"
        },
        {
          Action = [
            "apigateway:AddCertificateToDomain",
            "apigateway:RemoveCertificateFromDomain",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:apigateway:eu-west-2::/domainnames/*",
            "arn:aws:apigateway:eu-west-2::/domainnames",
          ]
          Sid = "VisualEditor3"
        },
        {
          Action   = "apigateway:AddCertificateToDomain"
          Effect   = "Allow"
          Resource = "arn:aws:apigateway:eu-west-2::/domainnames"
          Sid      = "VisualEditor4"
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags     = {}
  tags_all = {}
}


# aws_iam_policy.github_terraform_tagging_policy_dev[0]:
resource "aws_iam_policy" "github_terraform_tagging_policy_dev" {
  count       = var.environment == "dev" ? 1 : 0
  description = null
  name        = "github_terraform_tagging_policy"
  name_prefix = null
  path        = "/"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "sns:TagResource",
            "backup:TagResource",
            "resource-groups:GetGroupQuery",
            "lambda:TagResource",
            "resource-groups:UpdateGroup",
            "iam:UntagRole",
            "iam:TagRole",
            "resource-groups:GetTags",
            "sns:UntagResource",
            "resource-groups:Untag",
            "lambda:UntagResource",
            "elasticloadbalancing:RemoveTags",
            "cognito-identity:UntagResource",
            "resource-groups:GetGroup",
            "resource-groups:GetGroupConfiguration",
            "backup:UntagResource",
            "cognito-identity:TagResource",
            "resource-groups:Tag",
            "resource-groups:UpdateGroupQuery",
            "iam:TagPolicy",
            "resource-groups:DeleteGroup",
            "events:TagResource",
            "elasticloadbalancing:AddTags",
            "iam:UntagPolicy",
            "resource-groups:ListGroupResources",
            "events:UntagResource",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:lambda:*:${var.aws_account_id}:event-source-mapping:*",
            "arn:aws:lambda:*:${var.aws_account_id}:function:*",
            "arn:aws:lambda:*:${var.aws_account_id}:code-signing-config:*",
            "arn:aws:iam::${var.aws_account_id}:role/*",
            "arn:aws:iam::${var.aws_account_id}:policy/*",
            "arn:aws:sns:*:${var.aws_account_id}:*",
            "arn:aws:backup:*:${var.aws_account_id}:legal-hold:*",
            "arn:aws:backup:*:${var.aws_account_id}:framework:*-*",
            "arn:aws:backup:*:${var.aws_account_id}:backup-vault:*",
            "arn:aws:backup:*:${var.aws_account_id}:report-plan:*-*",
            "arn:aws:backup:*:${var.aws_account_id}:backup-plan:*",
            "arn:aws:backup:*:${var.aws_account_id}:restore-testing-plan:*-*",
            "arn:aws:cognito-identity:*:${var.aws_account_id}:identitypool/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:loadbalancer/gwy/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:loadbalancer/net/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:loadbalancer/app/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:truststore/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:listener/app/*/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:listener/gwy/*/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:listener-rule/net/*/*/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:listener/net/*/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:listener-rule/app/*/*/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:targetgroup/*/*",
            "arn:aws:resource-groups:*:${var.aws_account_id}:group/*",
            "arn:aws:events:*:${var.aws_account_id}:event-bus/*",
            "arn:aws:events:*:${var.aws_account_id}:rule/*/*",
          ]
          Sid = "VisualEditor0"
        },
        {
          Action = [
            "events:TagResource",
            "elasticloadbalancing:RemoveTags",
            "elasticloadbalancing:AddTags",
            "events:UntagResource",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:loadbalancer/gwy/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:truststore/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:listener/app/*/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:listener/gwy/*/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:listener/net/*/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:listener-rule/net/*/*/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:listener-rule/app/*/*/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:targetgroup/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:loadbalancer/net/*/*",
            "arn:aws:elasticloadbalancing:*:${var.aws_account_id}:loadbalancer/app/*/*",
            "arn:aws:events:*:${var.aws_account_id}:rule/*",
          ]
          Sid = "VisualEditor1"
        },
        {
          Action = [
            "resource-groups:SearchResources",
            "resource-groups:CreateGroup",
            "resource-groups:ListGroups",
          ]
          Effect   = "Allow"
          Resource = "*"
          Sid      = "VisualEditor2"
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags     = {}
  tags_all = {}
}


# aws_iam_policy.lambda_github_access_policy_dev[0]:
resource "aws_iam_policy" "lambda_github_access_policy_dev" {
  count       = var.environment == "dev" ? 1 : 0
  description = "These permissions allow GitHub to push to a Lambda function."
  name        = "lambda-github-access-policy"
  name_prefix = null
  path        = "/"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "lambda:CreateFunction",
            "s3:PutObject",
            "lambda:UpdateFunctionCode",
            "kms:TagResource",
            "kms:UntagResource",
            "kms:Encrypt",
            "kms:Decrypt",
            "lambda:InvokeFunction",
            "lambda:GetFunction",
            "lambda:UpdateFunctionConfiguration",
            "lambda:GetFunctionConfiguration",
            "lambda:DeleteFunctionConcurrency",
            "kms:CreateGrant",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:kms:*:${var.aws_account_id}:key/*",
            "arn:aws:lambda:eu-west-2:*:function:*",
          ]
          Sid = "VisualEditor0"
        },
        {
          Action   = "iam:ListRoles"
          Effect   = "Allow"
          Resource = "arn:aws:lambda:eu-west-2:*:function:*"
          Sid      = "VisualEditor1"
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags     = {}
  tags_all = {}
}


# aws_iam_policy.repo_app_config_dev[0]:
resource "aws_iam_policy" "repo_app_config_dev" {
  count       = var.environment == "dev" ? 1 : 0
  description = null
  name        = "repo_app_config"
  name_prefix = null
  path        = "/"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "appconfig:ListTagsForResource",
            "appconfig:StartDeployment",
            "appconfig:DeleteApplication",
            "appconfig:GetLatestConfiguration",
            "appconfig:TagResource",
            "appconfig:CreateConfigurationProfile",
            "appconfig:CreateExtensionAssociation",
            "appconfig:DeleteConfigurationProfile",
            "appconfig:CreateDeploymentStrategy",
            "appconfig:CreateApplication",
            "appconfig:GetDeploymentStrategy",
            "appconfig:GetHostedConfigurationVersion",
            "appconfig:ListExtensionAssociations",
            "appconfig:ListDeploymentStrategies",
            "appconfig:CreateHostedConfigurationVersion",
            "appconfig:DeleteEnvironment",
            "appconfig:UntagResource",
            "appconfig:ListHostedConfigurationVersions",
            "appconfig:ListEnvironments",
            "appconfig:UpdateDeploymentStrategy",
            "appconfig:GetExtensionAssociation",
            "appconfig:GetExtension",
            "appconfig:ListDeployments",
            "appconfig:GetDeployment",
            "appconfig:ListExtensions",
            "appconfig:DeleteHostedConfigurationVersion",
            "appconfig:StopDeployment",
            "appconfig:CreateEnvironment",
            "appconfig:UpdateEnvironment",
            "appconfig:GetEnvironment",
            "appconfig:ListConfigurationProfiles",
            "appconfig:DeleteDeploymentStrategy",
            "appconfig:ListApplications",
            "appconfig:UpdateApplication",
            "appconfig:CreateExtension",
            "appconfig:GetConfiguration",
            "appconfig:GetApplication",
            "appconfig:UpdateConfigurationProfile",
            "appconfig:GetConfigurationProfile",
          ]
          Effect   = "Allow"
          Resource = "*"
          Sid      = "VisualEditor0"
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags     = {}
  tags_all = {}
}


# aws_iam_policy.terraform_github_dynamodb_access_policy_dev[0]:
resource "aws_iam_policy" "terraform_github_dynamodb_access_policy_dev" {
  count       = var.environment == "dev" ? 1 : 0
  description = "Dynamo DB specific access policies required by terraform via GitHub"
  name        = "terraform-github-dynamodb-access-policy"
  name_prefix = null
  path        = "/"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "dynamodb:DescribeTable",
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:DeleteItem",
            "dynamodb:UpdateTimeToLive",
          ]
          Effect   = "Allow"
          Resource = "arn:aws:dynamodb:*:*:table/ndr-terraform-locks"
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags     = {}
  tags_all = {}
}


# aws_iam_policy.terraform_github_s3_access_policy_dev[0]:
resource "aws_iam_policy" "terraform_github_s3_access_policy_dev" {
  count       = var.environment == "dev" ? 1 : 0
  description = "S3 specific access policies required by terraform via GitHub"
  name        = "terraform-github-s3-access-policy"
  name_prefix = null
  path        = "/"
  policy = jsonencode(
    {
      Statement = [
        {
          Action   = "s3:ListBucket"
          Effect   = "Allow"
          Resource = "arn:aws:s3:::ndr-dev-terraform-state-${var.aws_account_id}"
        },
        {
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:DeleteBucketPolicy",
            "s3:PutBucketPolicy",
          ]
          Effect   = "Allow"
          Resource = "arn:aws:s3:::ndr-dev-terraform-state-${var.aws_account_id}/ndr/terraform.tfstate"
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags     = {}
  tags_all = {}
}
