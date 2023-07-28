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
resource "aws_lb_target_group" "ecs" {
  name        = "ecs"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  tags = {
    Name = "lb_target_group-${var.ecs_cluster_name}"
    #    Owner       = var.owner
    #    Environment = var.environment
    Workspace = terraform.workspace
  }
}

#resource "aws_lb_listener" "https" {
#  load_balancer_arn = aws_lb.ecs-lb.arn
#  port              = "443"
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   =aws_acm_certificate_validation.elb_cert.certificate_arn
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.ecs.arn
#  }
#}
#
#resource "aws_lb_listener" "http" {
#  load_balancer_arn = aws_lb.elb.arn
#  port              = "80"
#  protocol          = "HTTP"
#
#  default_action {
#    type = "redirect"
#
#    redirect {
#      port        = "443"
#      protocol    = "HTTPS"
#      status_code = "HTTP_301"
#    }
#  }
#}
