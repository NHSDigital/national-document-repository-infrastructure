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
          containerPort = var.container_port
          hostPort      = var.container_port
      }]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group" : aws_cloudwatch_log_group.awslogs-ndr-ecs.name,
          "awslogs-region" : var.aws_region,
          "awslogs-create-group" : "true",
          "awslogs-stream-prefix" : terraform.workspace
        }
      }
      environment : [
        {
          "name" : "api_endpoint",
          "value" : try(var.api_resource.invoke_url, null)
        }
      ],
    }
  ])
}

resource "aws_cloudwatch_log_group" "awslogs-ndr-ecs" {
  name = "${terraform.workspace}-ecs-task"
}
