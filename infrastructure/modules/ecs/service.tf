resource "aws_ecs_service" "ndr_ecs_service" {
  name            = var.ecs_cluster_service_name
  cluster         = aws_ecs_cluster.ndr_esc_cluster.id
  task_definition = aws_ecs_task_definition.nsr_ecs_task.arn
  desired_count   = 3
  launch_type     = var.ecs_launch_type

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.ndr_ecs_sg.id]
    subnets          = [for subnet in var.public_subnets : subnet]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_lb_tg.arn
    container_name   = "${terraform.workspace}-app-container"
    container_port   = var.container_port
  }

  depends_on = [aws_lb_target_group.ecs_lb_tg]

  tags = {
    Name        = "${terraform.workspace}-ecs"
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}
