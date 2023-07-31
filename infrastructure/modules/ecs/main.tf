 resource "aws_ecs_cluster" "ndr_esc_cluster" {
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

resource "aws_ecs_service" "ndr_ecs_service" {
  name            = var.ecs_cluster_service_name
  cluster         = aws_ecs_cluster.ndr_esc_cluster.id
  task_definition = aws_ecs_task_definition.nsr_ecs_task.arn
  desired_count   = 3
  launch_type     = var.ecs_launch_type
  iam_role        = aws_iam_role.ecs_service.arn
  depends_on      = [aws_iam_role.ecs_service]

  network_configuration {
    assign_public_ip = false
    security_groups = [aws_security_group.ndr_ecs_sg.id]
    subnets         = [for subnet in var.public_subnets : subnet]
  }

  load_balancer {
    elb = aws_lb_target_group.ecs_lb_tg.arn
    container_name   = "${terraform.workspace}-app-container"
    container_port   = 8080
  }

  tags = {
    Name = "${terraform.workspace}-ecs"
    #   Environment = var.environment
    Workspace = terraform.workspace
}}


 resource "aws_ecs_task_definition" "nsr_ecs_task" {
   family = "ndr-service-task"
   execution_role_arn = aws_iam_role.ecs_service.arn
   network_mode             = "awsvpc"
   requires_compatibilities = ["FARGATE"]
   cpu                      = 1024
   memory                   = 2048

   container_definitions = jsonencode([
     {
       name      = "first"
#       image     = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${aws_ecr_repository.docker-backend.name}:latest"
       cpu       = 512
       memory    = 1024
       essential = true
       networkMode = "awsvpc"
       portMappings = [
         {
           containerPort = 80
           hostPort      = 80
         }]
     }
   ])
 }