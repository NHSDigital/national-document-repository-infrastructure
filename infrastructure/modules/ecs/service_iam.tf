resource "aws_iam_role" "ecs_service" {
  name = "${terraform.workspace}-ecs-service"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "ecs_service_elb" {
  role        = aws_iam_role.ecs_service.name
  name        = "${terraform.workspace}-to-elb"
  path        = "/"
  description = "Allow access to the service elb"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:RegisterTargets"
        ]
        Effect   = "Allow"
        Resource = aws_lb.ecs_lb.arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_service_standard" {
  role        = aws_iam_role.ecs_service.name
  name        = "dev-to-standard"
  path        = "/"
  description = "Allow standard ecs actions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeTags",
          "ecs:DeregisterContainerInstance",
          "ecs:DiscoverPollEndpoint",
          "ecs:Poll",
          "ecs:RegisterContainerInstance",
          "ecs:StartTelemetrySession",
          "ecs:UpdateContainerInstancesState",
          "ecs:Submit*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_service_scaling" {
  name        = "dev-to-scaling"
  path        = "/"
  description = "Allow ecs service scaling"
  role        = aws_iam_role.ecs_service.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "application-autoscaling:*",
          "ecs:DescribeServices",
          "ecs:UpdateService",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
