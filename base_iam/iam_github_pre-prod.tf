# aws_iam_role.pre_prod_github_actions[0]:
resource "aws_iam_role" "pre_prod_github_actions" {
  count                 = local.is_pre_production ? 1 : 0
  name                  = "${terraform.workspace}-github-actions-role"
  description           = "This role is to provide access for GitHub Actions to the ${terraform.workspace} environment."
  force_detach_policies = false
  max_session_duration  = 3600
  name_prefix           = null
  path                  = "/"
  permissions_boundary  = null
  tags                  = {}
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
            Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
}


# INLINE POLICIES

resource "aws_iam_role_policy" "cloudfront_policy_pre_prod" {
  count = local.is_pre_production ? 1 : 0
  role  = aws_iam_role.pre_prod_github_actions[0].name
  name  = "cloudfront_policy"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
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
            "cloudfront:UpdateOriginAccessControl",
            "cloudfront:CreateOriginRequestPolicy",
            "cloudfront:UpdateOriginRequestPolicy",
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

resource "aws_iam_role_policy" "cloudwatch_logs_policy_pre_prod" {
  count = local.is_pre_production ? 1 : 0
  role  = aws_iam_role.pre_prod_github_actions[0].name
  name  = "cloudwatch_logs_policy"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "logs:ListTagsLogGroup",
            "logs:CreateLogDelivery",
            "logs:PutMetricFilter",
            "logs:DeleteMetricFilter",
            "logs:DescribeLogGroups",
            "logs:PutRetentionPolicy",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:PutResourcePolicy",
          ]
          Effect   = "Allow"
          Resource = "*"
          Sid      = "AllowLogGroup"
        },
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy" "ecr_policy_pre_prod" {
  count = local.is_pre_production ? 1 : 0
  role  = aws_iam_role.pre_prod_github_actions[0].name
  name  = "ecr_policy"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "ecr:InitiateLayerUpload",
            "ecr:BatchDeleteImage",
            "ecr:CompleteLayerUpload",
            "ecr:InitiateLayerUpload",
            "ecr:PutImage",
            "ecr:UploadLayerPart",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:ecr:eu-west-2:${data.aws_caller_identity.current.account_id}:repository/ndr-pre-prod-app",
            "arn:aws:ecr:eu-west-2:${data.aws_caller_identity.current.account_id}:repository/pre-prod-data-collection",
          ]
          Sid = "AllowAppAndOdsUpdate"
        },
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy" "ecs_policy_pre_prod" {
  count = local.is_pre_production ? 1 : 0
  role  = aws_iam_role.pre_prod_github_actions[0].name
  name  = "ecs_policy"
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

resource "aws_iam_role_policy" "github_extended_policy_virus_scanner_pre_prod" {
  count = local.is_pre_production ? 1 : 0
  role  = aws_iam_role.pre_prod_github_actions[0].name
  name  = "github-extended-policy-virus-scanner"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "ssm:CreateDocument",
            "iam:TagRole",
            "SNS:TagResource",
            "cognito-idp:CreateUserPool",
            "cognito-idp:TagResource",
            "cognito-idp:SetUserPoolMfaConfig",
            "iam:CreateInstanceProfile",
            "iam:AddRoleToInstanceProfile",
            "iam:DeleteInstanceProfile",
            "cloudformation:CreateResource",
            "cognito-idp:DeleteUserPool",
            "cognito-idp:CreateGroup",
            "cognito-idp:AdminCreateUser",
            "cognito-idp:CreateUserPoolClient",
            "cognito-idp:AdminAddUserToGroup",
          ]
          Effect   = "Allow"
          Resource = "*"
          Sid      = "Statement1"
        },
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy" "lambda_pre_prod" {
  count = local.is_pre_production ? 1 : 0
  role  = aws_iam_role.pre_prod_github_actions[0].name
  name  = "lambda"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "lambda:CreateFunction",
            "lambda:DeleteFunctionConcurrency",
            "lambda:GetFunction",
            "lambda:GetFunctionConfiguration",
            "lambda:InvokeFunction",
            "lambda:UpdateFunctionCode",
            "lambda:UpdateFunctionConfiguration",
            "kms:CreateGrant",
            "kms:Decrypt",
            "kms:Encrypt",
            "kms:TagResource",
            "kms:UntagResource",
            "s3:PutObject",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*",
            "arn:aws:lambda:eu-west-2:*:function:*",
          ]
          Sid = "VisualEditor0"
        },
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy" "mtls_gateway_pre_prod" {
  count = local.is_pre_production ? 1 : 0
  role  = aws_iam_role.pre_prod_github_actions[0].name
  name  = "mtls-gateway"
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
            "arn:aws:acm:eu-west-2:${data.aws_caller_identity.current.account_id}:certificate/*",
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
}

resource "aws_iam_role_policy" "resource_tagging_pre_prod" {
  count = local.is_pre_production ? 1 : 0
  role  = aws_iam_role.pre_prod_github_actions[0].name
  name  = "resource_tagging"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
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
          Effect = "Allow"
          Resource = [
            "arn:aws:events:*:${data.aws_caller_identity.current.account_id}:event-bus/*",
            "arn:aws:events:*:${data.aws_caller_identity.current.account_id}:rule/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/gwy/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/net/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/app/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:truststore/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/app/*/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/gwy/*/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener-rule/net/*/*/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/net/*/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener-rule/app/*/*/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:targetgroup/*/*",
            "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:event-source-mapping:*",
            "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:code-signing-config:*",
            "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:function:*",
            "arn:aws:cognito-identity:*:${data.aws_caller_identity.current.account_id}:identitypool/*",
            "arn:aws:resource-groups:*:${data.aws_caller_identity.current.account_id}:group/*",
            "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:backup-plan:*",
            "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:report-plan:*-*",
            "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:restore-testing-plan:*-*",
            "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:backup-vault:*",
            "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:legal-hold:*",
            "arn:aws:backup:*:${data.aws_caller_identity.current.account_id}:framework:*-*",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/*",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/*",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*",
            "arn:aws:sns:*:${data.aws_caller_identity.current.account_id}:*",
            "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:*",
            "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:delivery-source:*",
            "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:delivery:*",
            "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:destination:*",
            "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:delivery-destination:*",
            "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:anomaly-detector:*",
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
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/app/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/net/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:targetgroup/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:truststore/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/gwy/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/gwy/*/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/app/*/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/net/*/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener-rule/app/*/*/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener-rule/net/*/*/*/*",
            "arn:aws:events:*:${data.aws_caller_identity.current.account_id}:rule/*",
          ]
          Sid = "VisualEditor1"
        },
        {
          Action = [
            "elasticloadbalancing:RemoveTags",
            "elasticloadbalancing:AddTags",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:truststore/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/app/*/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/gwy/*/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener/net/*/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener-rule/net/*/*/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:listener-rule/app/*/*/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:targetgroup/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/gwy/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/net/*/*",
            "arn:aws:elasticloadbalancing:*:${data.aws_caller_identity.current.account_id}:loadbalancer/app/*/*",
          ]
          Sid = "VisualEditor2"
        },
        {
          Action = [
            "resource-groups:SearchResources",
            "resource-groups:CreateGroup",
            "resource-groups:ListGroups",
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

resource "aws_iam_role_policy" "rum_policy_pre_prod" {
  count = local.is_pre_production ? 1 : 0
  role  = aws_iam_role.pre_prod_github_actions[0].name
  name  = "rum_policy"
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
          Resource = "arn:aws:cognito-identity:eu-west-2:${data.aws_caller_identity.current.account_id}:identitypool/*"
          Sid      = "AllowIdentityPool"
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
          Resource = "arn:aws:rum:eu-west-2:${data.aws_caller_identity.current.account_id}:appmonitor/*"
          Sid      = "AllowAppMonitor"
        },
        {
          Action = [
            "logs:DeleteLogGroup",
            "logs:DeleteResourcePolicy",
            "logs:DescribeLogGroups",
          ]
          Effect   = "Allow"
          Resource = "arn:aws:logs:eu-west-2:${data.aws_caller_identity.current.account_id}:log-group:*RUMService*"
          Sid      = "AllowRumServiceLogs"
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
          Sid      = "AllowRumServiceAllLogs"
        },
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy" "scheduler_policy_pre_prod" {
  count = local.is_pre_production ? 1 : 0
  role  = aws_iam_role.pre_prod_github_actions[0].name
  name  = "scheduler_policy"
  policy = jsonencode(
    {
      Statement = [
        {
          Action   = "scheduler:DeleteSchedule"
          Effect   = "Allow"
          Resource = "*"
          Sid      = "VisualEditor0"
        },
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy" "step_functions_pre_prod" {
  count = local.is_pre_production ? 1 : 0
  role  = aws_iam_role.pre_prod_github_actions[0].name
  name  = "step_functions"
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
          Resource = "arn:aws:states:eu-west-2:${data.aws_caller_identity.current.account_id}:stateMachine:*"
          Sid      = "VisualEditor0"
        },
      ]
      Version = "2012-10-17"
    }
  )
}


# ATTACHED POLICIES

resource "aws_iam_role_policy_attachment" "ReadOnlyAccess_pre_prod" {
  count      = local.is_pre_production ? 1 : 0
  role       = aws_iam_role.pre_prod_github_actions[0].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "github_actions_policy_pre_prod" {
  count      = local.is_pre_production ? 1 : 0
  role       = aws_iam_role.pre_prod_github_actions[0].name
  policy_arn = aws_iam_policy.github_actions_policy_pre_prod[0].arn
}

# aws_iam_policy.github_actions_policy_pre_prod[0]:
resource "aws_iam_policy" "github_actions_policy_pre_prod" {
  count       = local.is_pre_production ? 1 : 0
  description = null
  name        = "github-actions-policy"
  name_prefix = null
  path        = "/"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "apigateway:DELETE",
            "apigateway:PATCH",
            "apigateway:POST",
            "apigateway:PUT",
            "cloudwatch:DeleteAlarms",
            "cloudwatch:PutMetricAlarm",
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
            "dynamodb:UpdateTimeToLive",
            "ec2:AssociateRouteTable",
            "ec2:AttachInternetGateway",
            "ec2:AuthorizeSecurityGroupEgress",
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:CreateDefaultVpc",
            "ec2:CreateInternetGateway",
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
            "ec2:DisassociateRouteTable",
            "ec2:ModifyVpcAttribute",
            "ec2:ModifyVpcEndpoint",
            "ec2:RevokeSecurityGroupEgress",
            "ec2:RevokeSecurityGroupIngress",
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
            "ecs:RegisterTaskDefinition",
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
            "elasticloadbalancing:ModifyLoadBalancerAttributes",
            "elasticloadbalancing:ModifyTargetGroupAttributes",
            "elasticloadbalancing:SetSecurityGroups",
            "events:PutRule",
            "events:PutTargets",
            "iam:AttachRolePolicy",
            "iam:CreatePolicy",
            "iam:CreatePolicyVersion",
            "iam:CreateRole",
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
            "kms:RetireGrant",
            "lambda:AddPermission",
            "lambda:CreateEventSourceMapping",
            "lambda:DeleteEventSourceMapping",
            "lambda:DeleteFunction",
            "lambda:GetPolicy",
            "lambda:RemovePermission",
            "logs:CreateLogGroup",
            "logs:DeleteLogGroup",
            "logs:DescribeLogGroups",
            "logs:ListTagsLogGroup",
            "route53:AssociateVPCWithHostedZone",
            "route53:ChangeResourceRecordSets",
            "route53:GetChange",
            "route53:GetHostedZone",
            "route53:ListHostedZones",
            "route53:ListResourceRecordSets",
            "route53:ListTagsForResource",
            "s3:CreateBucket",
            "s3:DeleteBucket",
            "s3:DeleteBucketPolicy",
            "s3:DeleteObject",
            "s3:DeleteObjectTagging",
            "s3:DeleteObjectVersion",
            "s3:DeleteObjectVersionTagging",
            "s3:GetAccelerateConfiguration",
            "s3:GetBucketAcl",
            "s3:GetBucketCORS",
            "s3:GetBucketLogging",
            "s3:GetBucketObjectLockConfiguration",
            "s3:GetBucketOwnershipControls",
            "s3:GetBucketPolicy",
            "s3:GetBucketRequestPayment",
            "s3:GetBucketTagging",
            "s3:GetBucketVersioning",
            "s3:GetBucketWebsite",
            "s3:GetEncryptionConfiguration",
            "s3:GetLifecycleConfiguration",
            "s3:GetObject",
            "s3:GetReplicationConfiguration",
            "s3:ListBucket",
            "s3:PutBucketAcl",
            "s3:PutBucketCORS",
            "s3:PutBucketOwnershipControls",
            "s3:PutBucketPolicy",
            "s3:PutBucketTagging",
            "s3:PutLifecycleConfiguration",
            "s3:PutObject",
            "secretsmanager:DeleteSecret",
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
            "events:RemoveTargets",
            "wafv2:CreateRegexPatternSet",
            "wafv2:TagResource",
            "wafv2:CreateWebACL",
            "wafv2:AssociateWebACL",
            "elasticloadbalancing:SetWebACL",
            "events:DeleteRule",
            "wafv2:DeleteRegexPatternSet",
            "wafv2:DeleteWebACL",
            "s3:PutIntelligentTieringConfiguration",
            "ecs:UntagResource",
            "lambda:UpdateFunctionConfiguration",
            "lambda:UpdateFunctionCode",
            "sqs:tagqueue",
            "kms:TagResource",
            "wafv2:UpdateWebACL",
            "dynamodb:UpdateTable",
            "kms:CreateKey",
            "dynamodb:UpdateContinuousBackups",
            "backup:CreateBackupVault",
            "application-autoscaling:RegisterScalableTarget",
            "application-autoscaling:TagResource",
            "s3:PutBucketVersioning",
            "kms:CreateAlias",
            "kms:DeleteAlias",
            "kms:DescribeKey",
            "kms:EnableKeyRotation",
            "kms:GetKeyPolicy",
            "kms:GetKeyRotationStatus",
            "kms:ListAliases",
            "kms:ListKeys",
            "kms:ListResourceTags",
            "kms:PutKeyPolicy",
            "kms:UntagResource",
            "kms:UpdateAlias",
            "kms:UpdateKeyDescription",
            "kms:ScheduleKeyDeletion",
            "application-autoscaling:PutScalingPolicy",
            "application-autoscaling:DeleteScalingPolicy",
            "application-autoscaling:DeregisterScalableTarget",
            "application-autoscaling:UntagResource",
            "application-autoscaling:ListTagsForResource",
            "cloudwatch:TagResource",
            "cloudwatch:UntagResource",
            "cloudwatch:ListTagsForResource",
            "backup-storage:MountCapsule",
            "backup:CreateBackupPlan",
            "lambda:PutFunctionConcurrency",
            "backup:CreateBackupSelection",
            "backup:UpdateBackupPlan",
            "backup:DescribeBackupJob",
            "backup:ListTags",
            "backup:TagResource",
            "backup:DeleteBackupVault",
            "backup:DeleteBackupSelection",
            "iam:UpdateRoleDescription",
            "logs:PutMetricFilter",
            "ec2:AllocateAddress",
            "ec2:CreateNatGateway",
            "scheduler:CreateSchedule",
            "scheduler:UpdateSchedule",
          ]
          Effect   = "Allow"
          Resource = "*"
          Sid      = "Statement1"
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags = {}
}

resource "aws_iam_role_policy_attachment" "github_extended_policy_1_pre_prod" {
  count      = local.is_pre_production ? 1 : 0
  role       = aws_iam_role.pre_prod_github_actions[0].name
  policy_arn = aws_iam_policy.github_extended_policy_1_pre_prod[0].arn
}

# aws_iam_policy.github_extended_policy_1_pre_prod[0]:
resource "aws_iam_policy" "github_extended_policy_1_pre_prod" {
  count       = local.is_pre_production ? 1 : 0
  description = "more required items for GitHub access"
  name        = "github-extended-policy-1"
  name_prefix = null
  path        = "/"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "ses:SetIdentityMailFromDomain",
            "lambda:CreateFunction",
            "appconfig:StartDeployment",
            "elasticloadbalancing:ModifyListener",
            "appconfig:TagResource",
            "appconfig:CreateDeploymentStrategy",
            "lambda:ListLayers",
            "ecs:TagResource",
            "appconfig:DeleteHostedConfigurationVersion",
            "lambda:PublishVersion",
            "dynamodb:UpdateTable",
            "ec2:DisassociateAddress",
            "kms:ListResourceTags",
            "ecr:ListTagsForResource",
            "lambda:RemoveLayerVersionPermission",
            "ses:VerifyDomainIdentity",
            "ecs:DeregisterTaskDefinition",
            "apigateway:DELETE",
            "logs:DeleteMetricFilter",
            "apigateway:SetWebACL",
            "ec2:DescribeAvailabilityZones",
            "backup:CreateBackupSelection",
            "kms:CreateKey",
            "ec2:ReleaseAddress",
            "kms:EnableKeyRotation",
            "ecr:PutLifecyclePolicy",
            "lambda:UpdateEventSourceMapping",
            "backup:DeleteBackupVault",
            "kms:GetKeyPolicy",
            "route53:ListHostedZones",
            "elasticloadbalancing:DeleteTargetGroup",
            "appconfig:CreateEnvironment",
            "backup:DescribeBackupVault",
            "events:DeleteRule",
            "iam:CreateServiceLinkedRole",
            "appconfig:DeleteDeploymentStrategy",
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
            "appconfig:CreateApplication",
            "ec2:AssociateRouteTable",
            "ec2:DescribeInternetGateways",
            "elasticloadbalancing:DeleteLoadBalancer",
            "backup:DeleteBackupSelection",
            "iam:DetachRolePolicy",
            "cloudwatch:UntagResource",
            "iam:ListAttachedRolePolicies",
            "dynamodb:GetItem",
            "lambda:ListLayerVersions",
            "ec2:DescribeRouteTables",
            "elasticloadbalancing:ModifyTargetGroupAttributes",
            "application-autoscaling:RegisterScalableTarget",
            "dynamodb:PutItem",
            "ecs:CreateCluster",
            "ec2:CreateRouteTable",
            "route53:ChangeResourceRecordSets",
            "lambda:AddLayerVersionPermission",
            "ec2:DetachInternetGateway",
            "logs:CreateLogGroup",
            "ecr:DeleteLifecyclePolicy",
            "backup-storage:MountCapsule",
            "ecs:DescribeClusters",
            "ssm:PutParameter",
            "elasticloadbalancing:DescribeLoadBalancerAttributes",
            "logs:PutMetricFilter",
            "ec2:DescribeSecurityGroupRules",
            "elasticloadbalancing:DescribeTargetGroupAttributes",
            "s3:PutBucketLogging",
            "application-autoscaling:PutScalingPolicy",
            "ec2:DescribeVpcEndpoints",
            "appconfig:CreateConfigurationProfile",
            "route53:GetChange",
            "lambda:GetLayerVersion",
            "lambda:PublishLayerVersion",
            "ses:VerifyDomainDkim",
            "lambda:CreateEventSourceMapping",
            "lambda:GetLayerVersionPolicy",
            "kms:TagResource",
            "dynamodb:TagResource",
            "elasticloadbalancing:DescribeListeners",
            "ec2:CreateSecurityGroup",
            "apigateway:PATCH",
            "appconfig:CreateHostedConfigurationVersion",
            "lambda:DeleteLayerVersion",
            "application-autoscaling:ListTagsForResource",
            "kms:DescribeKey",
            "ec2:ModifyVpcAttribute",
            "ecs:UntagResource",
            "ecr:DeleteRepositoryPolicy",
            "s3:GetBucketPublicAccessBlock",
            "ec2:AuthorizeSecurityGroupEgress",
            "elasticloadbalancing:ModifyListenerAttributes",
            "s3:PutBucketPublicAccessBlock",
            "logs:DescribeLogGroups",
            "kms:UpdateKeyDescription",
            "logs:DeleteLogGroup",
            "elasticloadbalancing:DescribeTags",
            "ec2:DeleteRoute",
            "backup:DeleteRecoveryPoint",
            "ec2:AllocateAddress",
            "cloudwatch:PutMetricAlarm",
            "cloudwatch:TagResource",
            "ec2:CreateVpcEndpoint",
            "elasticloadbalancing:SetSecurityGroups",
            "lambda:DeleteFunctionConcurrency",
            "lambda:GetPolicy",
            "iam:DeletePolicyVersion",
            "ecr:GetRepositoryPolicy",
            "s3:PutBucketNotification",
            "iam:UpdateAssumeRolePolicy",
            "sqs:sendmessage",
            "kms:GenerateDataKey",
          ]
          Effect   = "Allow"
          Resource = "*"
          Sid      = "VisualEditor0"
        },
        {
          Action = [
            "acm:AddTagsToCertificate",
            "acm:DeleteCertificate",
          ]
          Effect   = "Allow"
          Resource = "arn:aws:acm:us-east-1:${data.aws_caller_identity.current.account_id}:certificate/*"
          Sid      = "VisualEditor1"
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags = {}
}
