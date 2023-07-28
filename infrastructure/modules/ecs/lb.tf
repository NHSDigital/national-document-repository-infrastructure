resource "aws_lb" "ecs-lb" {
  name               = "lb-${var.ecs_cluster_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ndr_ecs_sg.id]
  subnets            = [for subnet in var.public_subnets : subnet]

  enable_deletion_protection = true

  tags = {
    Name = "lb-${var.ecs_cluster_name}"
    #    Owner       = var.owner
    #    Environment = var.environment
    Workspace = terraform.workspace
  }
}
