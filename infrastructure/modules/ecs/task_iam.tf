resource "aws_iam_role" "task_exec" {
  name = "${terraform.workspace}-ecs-task"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : [
              "ecs-tasks.amazonaws.com"
            ]
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec" {
  role       = aws_iam_role.task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = aws_iam_role.task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_iam_role_policy_attachment" "log_access" {
  role       = aws_iam_role.task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
#resource "aws_iam_role_policy" "ecs_service_elb" {
#  role        = aws_iam_role.ecs_service.name
#  name        = "${terraform.workspace}-to-elb"
#
#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = [
#          "ec2:Describe*",
#        ]
#        Effect   = "Allow"
#        Resource = "*"
#      },
#      {
#        Action = [
#          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
#          "elasticloadbalancing:DeregisterTargets",
#          "elasticloadbalancing:Describe*",
#          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
#          "elasticloadbalancing:RegisterTargets"
#        ]
#        Effect   = "Allow"
#        Resource = aws_lb.ecs_lb.arn
#      }
#    ]
#  })
#}
#
#resource "aws_iam_role_policy" "ecs_service_standard" {
#  role        = aws_iam_role.ecs_service.name
#  name        = "dev-to-standard"
#
#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = [
#          "ec2:DescribeTags",
#          "ecs:DeregisterContainerInstance",
#          "ecs:DiscoverPollEndpoint",
#          "ecs:Poll",
#          "ecs:RegisterContainerInstance",
#          "ecs:StartTelemetrySession",
#          "ecs:UpdateContainerInstancesState",
#          "ecs:Submit*",
#          "logs:CreateLogGroup",
#          "logs:CreateLogStream",
#          "logs:PutLogEvents"
#        ]
#        Effect   = "Allow"
#        Resource = "*"
#      }
#    ]
#  })
#}
#
#resource "aws_iam_role_policy" "ecs_service_scaling" {
#  name        = "dev-to-scaling"
#  role        = aws_iam_role.ecs_service.name
#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = [
#          "application-autoscaling:*",
#          "ecs:DescribeServices",
#          "ecs:UpdateService",
#        ]
#        Effect   = "Allow"
#        Resource = "*"
#      }
#    ]
#  })
#}
