data "aws_ecr_repository" "mesh-forwarder-ecr" {
  name = "ndr-shared-mesh-forwarder"
}

resource "aws_ecs_service" "mesh_forwarder" {
  name            = "${var.environment}--mesh-forwarder-service"
  cluster         = aws_ecs_cluster.mesh-forwarder-ecs-cluster.id
  task_definition = aws_ecs_task_definition.forwarder.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [module.ndr-ecs-fargate.security_group_id]
    subnets         = [for subnet in module.ndr-vpc-ui.private_subnets : subnet]
  }
}

resource "aws_ecs_cluster" "mesh-forwarder-ecs-cluster" {
  name = "${var.environment}-mesh-forwarder-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "${var.environment}-mesh-forwarder"
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}


resource "aws_ecs_task_definition" "forwarder" {
  family = "mesh-forwarder"
  container_definitions = jsonencode([
    {
      name        = "mesh-forwarder"
      image       = data.aws_ecr_repository.mesh-forwarder-ecr.repository_url
      environment = local.mesh_ecs_environment_variables
      essential   = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group  = aws_cloudwatch_log_group.aws-logs-ndr-ecs-mesh-forwarder.name
          awslogs-region = var.aws_region
          awslogs-create-group : "true"
          awslogs-stream-prefix : terraform.workspace
        }
      }
    }
  ])
  cpu                      = 512
  memory                   = 1024
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  tags = {
    Name        = "${var.environment}-mesh-forwarder"
    Environment = var.environment
    Workspace   = terraform.workspace
  }
  execution_role_arn = aws_iam_role.ecs_execution.arn
  task_role_arn      = aws_iam_role.mesh_forwarder.arn
}

resource "aws_cloudwatch_log_group" "aws-logs-ndr-ecs-mesh-forwarder" {
  name = "${terraform.workspace}-mesh-forwarder-ecs-task"
}

data "aws_iam_policy_document" "ecs-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "ecr_policy_doc" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]

    resources = [
      "arn:aws:ecr:${var.aws_region}:${local.account_id}:repository/deductions/mesh-forwarder"
    ]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      aws_cloudwatch_log_group.aws-logs-ndr-ecs-mesh-forwarder.arn
    ]
  }

  statement {
    actions = [
      "ssm:Get*"
    ]
    resources = [
      "arn:aws:ssm:${var.aws_region}:${local.account_id}:parameter/repo/${var.environment}/user-input/external/mesh-mailbox*",
    ]
  }

  #  statement {
  #    actions = [
  #      "sns:Publish"
  #    ]
  #    resources = [
  #      aws_sns_topic.nems_events.arn,
  #    ]
  #  }
}

data "aws_iam_policy_document" "kms_policy_doc" {
  statement {
    actions = [
      "kms:*"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "mesh_forwarder" {
  name               = "${var.environment}-mesh-forwarder-EcsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.ecs-assume-role-policy.json
  description        = "Role assumed by mesh-forwarder ECS task"

  tags = {
    Name        = "${var.environment}-mesh-forwarder"
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

resource "aws_iam_role" "sns_failure_feedback_role" {
  name               = "${var.environment}-mesh-forwarder-sns-failure-feedback-role"
  assume_role_policy = data.aws_iam_policy_document.sns_service_assume_role_policy.json
  description        = "Allows logging of SNS delivery failures in mesh-forwarder"

  tags = {
    Environment = var.environment
    Name        = "${var.environment}-mesh-forwarder"
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

data "aws_iam_policy_document" "sns_service_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "sns.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "sns_failure_feedback_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
      "logs:PutRetentionPolicy"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "sns_failure_feedback_policy" {
  name   = "${var.environment}-mesh-forwarder-sns-failure-feedback"
  policy = data.aws_iam_policy_document.sns_failure_feedback_policy.json
}

resource "aws_iam_role_policy_attachment" "sns_failure_feedback_policy_attachment" {
  role       = aws_iam_role.sns_failure_feedback_role.name
  policy_arn = aws_iam_policy.sns_failure_feedback_policy.arn
}

resource "aws_iam_policy" "mesh_forwarder_ecr" {
  name   = "${var.environment}-mesh-forwarder-ecr"
  policy = data.aws_iam_policy_document.ecr_policy_doc.json
}

resource "aws_iam_policy" "mesh_forwarder_kms" {
  name   = "${var.environment}-mesh-forwarder-kms"
  policy = data.aws_iam_policy_document.kms_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "mesh_forwarder_ecr" {
  role       = aws_iam_role.mesh_forwarder.name
  policy_arn = aws_iam_policy.mesh_forwarder_ecr.arn
}

#resource "aws_iam_role_policy_attachment" "mesh_forwarder_sns" {
#  role       = aws_iam_role.mesh_forwarder.name
#  policy_arn = aws_iam_policy.mesh_forwarder_sns.arn
#}

resource "aws_iam_role_policy_attachment" "mesh_forwarder_kms" {
  role       = aws_iam_role.mesh_forwarder.name
  policy_arn = aws_iam_policy.mesh_forwarder_kms.arn
}

resource "aws_iam_role" "ecs_execution" {
  name               = "${var.environment}-deductions-mesh-forwarder-task"
  description        = "ECS task role for launching mesh s3 forwarder"
  assume_role_policy = data.aws_iam_policy_document.ecs_execution.json

}

data "aws_iam_policy_document" "ecs_execution" {
  statement {
    sid = "GetEcrAuthToken"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "DownloadEcrImage"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = [
      data.aws_ecr_repository.mesh-forwarder-ecr.arn
    ]
  }

  statement {
    sid = "CloudwatchLogs"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.aws-logs-ndr-ecs-mesh-forwarder.arn}:*"
    ]
  }

  depends_on = [data.aws_ecr_repository.mesh-forwarder-ecr, aws_cloudwatch_log_group.aws-logs-ndr-ecs-mesh-forwarder]
}