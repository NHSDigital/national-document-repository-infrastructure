resource "aws_ecs_cluster" "ndr-esc-cluster" {
  name = var.ecs_cluster_name

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_cluster_logs.name
      }
    }
  }

  tags = {
    Name = "${terraform.workspace}-ecs"
    #   Environment = var.environment
    Workspace = terraform.workspace
  }
}

resource "aws_cloudwatch_log_group" "ecs_cluster_logs" {
  name = "${var.ecs_cluster_name}-logs"
}
resource "aws_iam_role" "ecs_policy" {
  name        = "${terraform.workspace}_ecs_policy"
  description = "Policy for running ecs service"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecs:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
  tags = {
    Name = "${terraform.workspace}-ecs"
    #   Environment = var.environment
    Workspace = terraform.workspace
  }
}

#resource "aws_ecs_service" "mongo" {
#  name            = var.ecs_cluster_service_name
#  cluster         = aws_ecs_cluster.ndr-esc-cluster.id
#  task_definition = aws_ecs_task_definition.mongo.arn
#  desired_count   = 3
#  launch_type     = var.ecs_launch_type
#  iam_role        = aws_iam_role.ecs_policy.arn
#  depends_on      = [aws_iam_role.ecs_policy]
#
#  ordered_placement_strategy {
#    type  = "binpack"
#    field = "cpu"
#  }
#
#  load_balancer {
#    elb = aws_lb_target_group.foo.arn
#    container_name   = "mongo"
#    container_port   = 8080
#  }
#
#  placement_constraints {
#    type       = "memberOf"
#    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
#  }
#}