resource "aws_ecs_task_definition" "nsr_ecs_task" {
  family                   = "ndr-service-task"
  execution_role_arn       = aws_iam_role.ecs_service.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  container_definitions = jsonencode([
    {
      name = "first"
      #       image     = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${aws_ecr_repository.docker-backend.name}:latest"
      cpu         = 512
      memory      = 1024
      essential   = true
      networkMode = "awsvpc"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
      }]
    }
  ])
}