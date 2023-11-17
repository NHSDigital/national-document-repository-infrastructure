resource "aws_ecs_service" "ndr_ecs_service" {
  name            = var.ecs_cluster_service_name
  cluster         = aws_ecs_cluster.ndr_esc_cluster.id
  task_definition = aws_ecs_task_definition.nsr_ecs_task.arn
  desired_count   = 3
  launch_type     = var.ecs_launch_type

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.ndr_ecs_sg.id]
    subnets          = [for subnet in var.private_subnets : subnet]
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

resource "aws_appautoscaling_target" "ndr_ecs_service_autoscale_target" {
  max_capacity       = 6
  min_capacity       = 3
  resource_id        = "service/${aws_ecs_cluster.ndr_esc_cluster.name}/${aws_ecs_service.ndr_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_cluster.ndr_esc_cluster, aws_ecs_service.ndr_ecs_service]

  tags = {
    Name        = "${terraform.workspace}-ecs-service-autoscale-target"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

resource "aws_appautoscaling_policy" "ndr_ecs_service_autoscale_up" {
  name               = "${terraform.workspace}-${var.ecs_cluster_name}-${var.ecs_cluster_service_name}-autoscale-up-policy"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ndr_ecs_service_autoscale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ndr_ecs_service_autoscale_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ndr_ecs_service_autoscale_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = 1
    }
  }

  tags = {
    Name        = "${terraform.workspace}-ecs-service-autoscale-up-policy"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

resource "aws_appautoscaling_policy" "ndr_ecs_service_autoscale_down" {
  name               = "${terraform.workspace}-${var.ecs_cluster_name}-${var.ecs_cluster_service_name}-autoscale-down-policy"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ndr_ecs_service_autoscale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ndr_ecs_service_autoscale_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ndr_ecs_service_autoscale_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  tags = {
    Name        = "${terraform.workspace}-ecs-service-autoscale-down-policy"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}
