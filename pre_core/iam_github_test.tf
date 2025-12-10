# aws_iam_role.github_role_test[0]:
resource "aws_iam_role" "github_role_test" {
    count = var.environment == "test" ? 1 : 0
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRoleWithWebIdentity"
                    Condition = {
                        StringEquals = {
                            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
                        }
                        StringLike   = {
                            "token.actions.githubusercontent.com:sub" = [
                                "repo:NHSDigital/national-document-repository-infrastructure:*",
                                "repo:NHSDigital/national-document-repository:*",
                            ]
                        }
                    }
                    Effect    = "Allow"
                    Principal = {
                        Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    description           = "This role is for the deployment of infrastructure and code from GitHub"
    force_detach_policies = false
    managed_policy_arns   = [
        "arn:aws:iam::${var.aws_account_id}:policy/github-action-policy",
        "arn:aws:iam::${var.aws_account_id}:policy/github-action-policy-2",
        "arn:aws:iam::aws:policy/ReadOnlyAccess",
    ]
    max_session_duration  = 3600
    name                  = "github-action-role"
    name_prefix           = null
    path                  = "/"
    permissions_boundary  = null
    tags                  = {}
    tags_all              = {}

    inline_policy {
        name   = "cloudfront_policies"
        policy = jsonencode(
            {
                Statement = [
                    {
                        Action   = [
                            "cloudfront:CreateCachePolicy",
                            "cloudfront:DeleteCachePolicy",
                            "cloudfront:CreateOriginAccessControl",
                            "cloudfront:CreateDistribution",
                            "cloudfront:TagResource",
                            "cloudfront:UntagResource",
                            "cloudfront:DeleteDistribution",
                            "lambda:EnableReplication",
                            "cloudfront:UpdateDistribution",
                            "cloudfront:DeleteOriginAccessControl",
                            "cloudfront:CreateInvalidation",
                            "cloudfront:CreateOriginRequestPolicy",
                            "cloudfront:DeleteOriginRequestPolicy",
                            "cloudfront:UpdateOriginRequestPolicy",
                        ]
                        Effect   = "Allow"
                        Resource = "*"
                        Sid      = "VisualEditor0"
                    },
                ]
                Version   = "2012-10-17"
            }
        )
    }
    inline_policy {
        name   = "cloudwatch_logs_policy"
        policy = jsonencode(
            {
                Statement = [
                    {
                        Action   = [
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
                ]
                Version   = "2012-10-17"
            }
        )
    }
    inline_policy {
        name   = "resource_tagging"
        policy = jsonencode(
            {
                Statement = [
                    {
                        Action   = [
                            "resource-groups:GetGroupQuery",
                            "backup:TagResource",
                            "sns:TagResource",
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
                            "logs:UntagResource",
                            "resource-groups:UpdateGroupQuery",
                            "iam:TagPolicy",
                            "logs:TagResource",
                            "events:TagResource",
                            "resource-groups:DeleteGroup",
                            "elasticloadbalancing:AddTags",
                            "iam:UntagPolicy",
                            "resource-groups:ListGroupResources",
                            "iam:UntagInstanceProfile",
                            "events:UntagResource",
                            "iam:TagInstanceProfile",
                        ]
                        Effect   = "Allow"
                        Resource = [
                            "arn:aws:events:*:694282683086:event-bus/*",
                            "arn:aws:events:*:694282683086:rule/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/gwy/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/net/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/app/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:truststore/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:listener/app/*/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:listener/gwy/*/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:listener-rule/net/*/*/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:listener/net/*/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:listener-rule/app/*/*/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:targetgroup/*/*",
                            "arn:aws:lambda:*:694282683086:event-source-mapping:*",
                            "arn:aws:lambda:*:694282683086:code-signing-config:*",
                            "arn:aws:lambda:*:694282683086:function:*",
                            "arn:aws:cognito-identity:*:694282683086:identitypool/*",
                            "arn:aws:resource-groups:*:694282683086:group/*",
                            "arn:aws:backup:*:694282683086:backup-plan:*",
                            "arn:aws:backup:*:694282683086:report-plan:*-*",
                            "arn:aws:backup:*:694282683086:restore-testing-plan:*-*",
                            "arn:aws:backup:*:694282683086:backup-vault:*",
                            "arn:aws:backup:*:694282683086:legal-hold:*",
                            "arn:aws:backup:*:694282683086:framework:*-*",
                            "arn:aws:iam::694282683086:policy/*",
                            "arn:aws:iam::694282683086:instance-profile/*",
                            "arn:aws:iam::694282683086:role/*",
                            "arn:aws:sns:*:694282683086:*",
                            "arn:aws:logs:*:694282683086:log-group:*",
                            "arn:aws:logs:*:694282683086:delivery-source:*",
                            "arn:aws:logs:*:694282683086:delivery:*",
                            "arn:aws:logs:*:694282683086:destination:*",
                            "arn:aws:logs:*:694282683086:delivery-destination:*",
                            "arn:aws:logs:*:694282683086:anomaly-detector:*",
                            "*",
                        ]
                        Sid      = "VisualEditor0"
                    },
                    {
                        Action   = [
                            "events:TagResource",
                            "elasticloadbalancing:RemoveTags",
                            "elasticloadbalancing:AddTags",
                            "events:UntagResource",
                        ]
                        Effect   = "Allow"
                        Resource = [
                            "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/app/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/net/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:targetgroup/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:truststore/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/gwy/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:listener/gwy/*/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:listener/app/*/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:listener/net/*/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:listener-rule/app/*/*/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:listener-rule/net/*/*/*/*",
                            "arn:aws:events:*:694282683086:rule/*",
                        ]
                        Sid      = "VisualEditor1"
                    },
                    {
                        Action   = [
                            "elasticloadbalancing:RemoveTags",
                            "elasticloadbalancing:AddTags",
                        ]
                        Effect   = "Allow"
                        Resource = [
                            "arn:aws:elasticloadbalancing:*:694282683086:truststore/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:listener/app/*/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:listener/gwy/*/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:listener/net/*/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:listener-rule/net/*/*/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:listener-rule/app/*/*/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:targetgroup/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/gwy/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/net/*/*",
                            "arn:aws:elasticloadbalancing:*:694282683086:loadbalancer/app/*/*",
                        ]
                        Sid      = "VisualEditor2"
                    },
                    {
                        Action   = [
                            "resource-groups:SearchResources",
                            "resource-groups:CreateGroup",
                            "resource-groups:ListGroups",
                        ]
                        Effect   = "Allow"
                        Resource = "*"
                        Sid      = "VisualEditor3"
                    },
                ]
                Version   = "2012-10-17"
            }
        )
    }
    inline_policy {
        name   = "rum_policy"
        policy = jsonencode(
            {
                Statement = [
                    {
                        Action   = [
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
                        Action   = [
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
                        Action   = [
                            "logs:DeleteLogGroup",
                            "logs:DeleteResourcePolicy",
                            "logs:DescribeLogGroups",
                        ]
                        Effect   = "Allow"
                        Resource = "arn:aws:logs:eu-west-2:${var.aws_account_id}:log-group:*RUMService*"
                        Sid      = "VisualEditor2"
                    },
                    {
                        Action   = [
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
                Version   = "2012-10-17"
            }
        )
    }
    inline_policy {
        name   = "scheduler-policy"
        policy = jsonencode(
            {
                Statement = [
                    {
                        Action   = [
                            "scheduler:TagResource",
                            "scheduler:CreateSchedule",
                            "scheduler:UntagResource",
                            "scheduler:DeleteSchedule",
                            "scheduler:UpdateSchedule",
                        ]
                        Effect   = "Allow"
                        Resource = "*"
                        Sid      = "VisualEditor0"
                    },
                ]
                Version   = "2012-10-17"
            }
        )
    }
    inline_policy {
        name   = "virus-scan-cognito"
        policy = jsonencode(
            {
                Statement = [
                    {
                        Action   = [
                            "cognito-idp:TagResource",
                            "cognito-idp:DeleteUserPool",
                            "cognito-idp:AdminCreateUser",
                            "cognito-idp:CreateUserPoolClient",
                            "cognito-idp:CreateGroup",
                            "cognito-idp:CreateUserPool",
                            "cognito-idp:SetUserPoolMfaConfig",
                            "cognito-idp:AdminAddUserToGroup",
                            "cloudformation:CreateResource",
                            "cloudformation:DeleteResource",
                            "cognito-idp:DeleteGroup",
                            "appconfig:DeleteEnvironment",
                            "appconfig:DeleteConfigurationProfile",
                            "iam:RemoveRoleFromInstanceProfile",
                            "cognito-idp:DeleteUserPoolClient",
                            "cognito-idp:AdminRemoveUserFromGroup",
                            "cognito-idp:AdminDeleteUser",
                        ]
                        Effect   = "Allow"
                        Resource = "*"
                        Sid      = "VisualEditor0"
                    },
                ]
                Version   = "2012-10-17"
            }
        )
    }
}


# aws_iam_policy.github_action_policy_test[0]:
resource "aws_iam_policy" "github_action_policy_test" {
    count = var.environment == "test" ? 1 : 0
    description      = null
    name             = "github-action-policy"
    name_prefix      = null
    path             = "/"
    policy           = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "ec2:AuthorizeSecurityGroupIngress",
                        "ec2:DeleteVpcEndpoints",
                        "ec2:AttachInternetGateway",
                        "iam:PutRolePolicy",
                        "ecr:DeleteRepository",
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
                        "elasticloadbalancing:CreateTargetGroup",
                        "ecr:GetAuthorizationToken",
                        "application-autoscaling:DeleteScalingPolicy",
                        "kms:RetireGrant",
                        "elasticloadbalancing:AddTags",
                        "ec2:DeleteNatGateway",
                        "apigateway:POST",
                        "lambda:DeleteEventSourceMapping",
                        "elasticloadbalancing:ModifyLoadBalancerAttributes",
                        "ec2:ModifyVpcEndpoint",
                        "logs:ListTagsLogGroup",
                        "kms:PutKeyPolicy",
                        "events:PutRule",
                        "ec2:CreateVpc",
                        "dynamodb:ListTagsOfResource",
                        "iam:PassRole",
                        "sqs:createqueue",
                        "iam:DeleteRolePolicy",
                        "application-autoscaling:TagResource",
                        "elasticloadbalancing:CreateLoadBalancer",
                        "lambda:UpdateEventSourceMapping",
                        "apigateway:PUT",
                        "route53:ListTagsForResource",
                        "ec2:DescribeSecurityGroups",
                        "iam:CreatePolicy",
                        "sqs:TagQueue",
                        "kms:CreateAlias",
                        "elasticloadbalancing:DescribeTargetGroups",
                        "route53:AssociateVPCWithHostedZone",
                        "elasticloadbalancing:DeleteListener",
                        "iam:GetPolicyVersion",
                        "wafv2:AssociateWebACL",
                        "ec2:DeleteSubnet",
                        "elasticloadbalancing:SetWebACL",
                        "elasticloadbalancing:DescribeLoadBalancers",
                        "ecs:UpdateService",
                        "ssm:DeleteParameter",
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
                        "lambda:PutFunctionConcurrency",
                        "dynamodb:UpdateContinuousBackups",
                        "elasticloadbalancing:CreateListener",
                        "ecs:CreateService",
                        "kms:ScheduleKeyDeletion",
                        "ecs:DescribeServices",
                        "ecr:DescribeRepositories",
                        "iam:CreatePolicyVersion",
                        "ecs:UntagResource",
                        "sqs:ListQueues",
                        "wafv2:UpdateWebACL",
                        "dynamodb:DescribeTimeToLive",
                        "kms:UpdateAlias",
                        "backup:GetBackupSelection",
                        "events:PutTargets",
                        "kms:ListKeys",
                        "lambda:AddPermission",
                        "ec2:DeleteSecurityGroup",
                        "ecr:SetRepositoryPolicy",
                        "application-autoscaling:DeregisterScalableTarget",
                        "backup:DeleteBackupPlan",
                        "sqs:DeleteMessage",
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
                        "ec2:RevokeSecurityGroupIngress",
                        "dynamodb:CreateTable",
                        "ec2:CreateDefaultVpc",
                        "ec2:CreateSubnet",
                        "ec2:DescribeSubnets",
                        "iam:GetRolePolicy",
                        "sqs:setqueueattributes",
                        "kms:UntagResource",
                        "ec2:CreateNatGateway",
                        "kms:ListResourceTags",
                        "ecr:ListTagsForResource",
                        "ecs:DeregisterTaskDefinition",
                        "apigateway:DELETE",
                        "backup:CreateBackupSelection",
                        "ec2:DescribeAvailabilityZones",
                        "kms:CreateKey",
                        "kms:EnableKeyRotation",
                        "ecr:PutLifecyclePolicy",
                        "s3:*",
                        "backup:DeleteBackupVault",
                        "kms:GetKeyPolicy",
                        "route53:ListHostedZones",
                        "elasticloadbalancing:DeleteTargetGroup",
                        "events:DeleteRule",
                        "backup:DescribeBackupVault",
                        "ec2:DescribeVpcs",
                        "kms:ListAliases",
                        "backup:CreateBackupPlan",
                        "lambda:RemovePermission",
                        "backup:ListTags",
                        "route53:GetHostedZone",
                        "iam:CreateRole",
                        "sns:Unsubscribe",
                        "iam:AttachRolePolicy",
                        "ec2:AssociateRouteTable",
                        "elasticloadbalancing:DeleteLoadBalancer",
                        "ec2:DescribeInternetGateways",
                        "iam:DetachRolePolicy",
                        "backup:DeleteBackupSelection",
                        "cloudwatch:UntagResource",
                        "iam:ListAttachedRolePolicies",
                        "dynamodb:GetItem",
                        "elasticloadbalancing:ModifyTargetGroupAttributes",
                        "ec2:DescribeRouteTables",
                        "application-autoscaling:RegisterScalableTarget",
                        "dynamodb:PutItem",
                        "ecs:CreateCluster",
                        "ec2:CreateRouteTable",
                        "route53:ChangeResourceRecordSets",
                        "ec2:DetachInternetGateway",
                        "logs:CreateLogGroup",
                        "ecr:DeleteLifecyclePolicy",
                        "backup-storage:MountCapsule",
                        "ecs:DescribeClusters",
                        "elasticloadbalancing:DescribeLoadBalancerAttributes",
                        "ssm:PutParameter",
                        "elasticloadbalancing:DescribeTargetGroupAttributes",
                        "ec2:DescribeSecurityGroupRules",
                        "application-autoscaling:PutScalingPolicy",
                        "ec2:DescribeVpcEndpoints",
                        "route53:GetChange",
                        "lambda:CreateEventSourceMapping",
                        "kms:TagResource",
                        "elasticloadbalancing:DescribeListeners",
                        "dynamodb:TagResource",
                        "ec2:CreateSecurityGroup",
                        "apigateway:PATCH",
                        "application-autoscaling:ListTagsForResource",
                        "kms:DescribeKey",
                        "ec2:ModifyVpcAttribute",
                        "ecr:DeleteRepositoryPolicy",
                        "ec2:AuthorizeSecurityGroupEgress",
                        "logs:DescribeLogGroups",
                        "kms:UpdateKeyDescription",
                        "logs:DeleteLogGroup",
                        "elasticloadbalancing:DescribeTags",
                        "ec2:DeleteRoute",
                        "backup:DeleteRecoveryPoint",
                        "cloudwatch:PutMetricAlarm",
                        "cloudwatch:TagResource",
                        "ec2:CreateVpcEndpoint",
                        "elasticloadbalancing:SetSecurityGroups",
                        "iam:DeletePolicyVersion",
                        "lambda:GetPolicy",
                        "ecr:GetRepositoryPolicy",
                        "ec2:AllocateAddress",
                        "ec2:ReleaseAddress",
                        "ec2:DisassociateAddress",
                        "logs:PutMetricFilter",
                        "logs:DeleteMetricFilter",
                        "ses:VerifyDomainIdentity",
                        "ses:VerifyDomainDkim",
                        "ses:DeleteIdentity",
                        "ses:SetIdentityMailFromDomain",
                        "dynamodb:UpdateTable",
                        "elasticloadbalancing:ModifyListener",
                        "lambda:GetLayerVersion",
                        "iam:CreatePolicyVersion",
                        "ecr:GetDownloadUrlForLayer",
                        "ecr:BatchGetImage",
                        "ecr:CompleteLayerUpload",
                        "ecr:UploadLayerPart",
                        "ecr:InitiateLayerUpload",
                        "ecr:BatchCheckLayerAvailability",
                        "s3:PutObject",
                        "iam:ListRoles",
                        "lambda:UpdateFunctionCode",
                        "lambda:CreateFunction",
                        "lambda:GetFunction",
                        "lambda:UpdateFunctionConfiguration",
                        "lambda:GetFunctionConfiguration",
                        "appconfig:ListTagsForResource",
                        "appconfig:StartDeployment",
                        "appconfig:DeleteApplication",
                        "appconfig:GetLatestConfiguration",
                        "ecr:PutImage",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "*",
                    ]
                    Sid      = "Statement1"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    tags             = {}
    tags_all         = {}
}


# aws_iam_policy.github_action_policy_2_test[0]:
resource "aws_iam_policy" "github_action_policy_2_test" {
    count = var.environment == "test" ? 1 : 0
    description      = null
    name             = "github-action-policy-2"
    name_prefix      = null
    path             = "/"
    policy           = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "acm:RequestCertificate",
                        "acm:AddTagsToCertificate",
                        "ecs:PutClusterCapacityProviders",
                        "backup:ListRecoveryPointsByBackupVault",
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
                        "dynamodb:DescribeTable",
                        "dynamodb:GetItem",
                        "dynamodb:PutItem",
                        "dynamodb:DeleteItem",
                        "dynamodb:UpdateTimeToLive",
                        "s3:GetObject",
                        "s3:PutObject",
                        "s3:DeleteObject",
                        "lambda:GetLayerVersion",
                        "lambda:PublishLayerVersion",
                        "lambda:DeleteLayerVersion",
                        "lambda:ListLayerVersions",
                        "lambda:ListLayers",
                        "lambda:AddLayerVersionPermission",
                        "lambda:GetLayerVersionPolicy",
                        "lambda:RemoveLayerVersionPermission",
                        "lambda:DeleteFunctionConcurrency",
                        "lambda:PublishVersion",
                        "iam:CreateServiceLinkedRole",
                        "iam:UpdateAssumeRolePolicy",
                        "elasticloadbalancing:ModifyListenerAttributes",
                        "apigateway:SetWebACL",
                        "backup:ListRecoveryPointsByBackupVault",
                        "iam:UpdateAssumeRolePolicy",
                        "iam:TagRole",
                        "iam:CreateInstanceProfile",
                        "iam:AddRoleToInstanceProfile",
                        "iam:DeleteInstanceProfile",
                        "iam:TagPolicy",
                        "ssm:CreateDocument",
                        "ssm:DeleteDocument",
                        "sns:TagResource",
                        "ec2:DeleteNetworkInterface",
                        "resource-groups:DeleteGroup",
                        "events:TagResource",
                        "kms:Encrypt",
                        "kms:CreateGrant",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "*",
                    ]
                    Sid      = "Statement1"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    tags             = {}
    tags_all         = {}
}


