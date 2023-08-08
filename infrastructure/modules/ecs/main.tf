resource "aws_ecs_task_definition" "nsr_ecs_task" {
  family                   = "${terraform.workspace}-ndr-service-task"
  execution_role_arn       = aws_iam_role.task_exec.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  container_definitions = jsonencode([
    {
      name        = "${terraform.workspace}-app-container"
      image       = var.ecr_repository_url
      cpu         = 512
      memory      = 1024
      essential   = true
      networkMode = "awsvpc"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
      }]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group" : "awslogs-${terraform.workspace}",
          "awslogs-region" : var.aws_region,
          "awslogs-stream-prefix" : "${terraform.workspace}r"
        }
      }
    }
  ])
}