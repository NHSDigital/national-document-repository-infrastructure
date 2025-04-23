resource "aws_ecs_cluster" "ndr_ecs_cluster" {
  name = "${terraform.workspace}-${var.ecs_cluster_name}"

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
    Name        = "${terraform.workspace}-ecs"
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

resource "aws_cloudwatch_log_group" "ecs_cluster_logs" {
  name              = "${terraform.workspace}-${var.ecs_cluster_name}-logs"
  retention_in_days = 0
}

resource "aws_ecs_cluster" "ndr-ecs-fargate-data-collection" {
  name = "${terraform.workspace}-${var.ecs_cluster_name}"

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_cluster_data_collection_logs.name
      }
    }
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "${terraform.workspace}-${var.ecs_cluster_name}"
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

resource "aws_cloudwatch_log_group" "ecs_cluster_data_collection_logs" {
  name              = "${terraform.workspace}-data-collection-logs"
  retention_in_days = 0
}
