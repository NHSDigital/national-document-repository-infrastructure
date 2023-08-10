resource "aws_route53_zone" "ndr_zone" {
  count = var.using_arf_hosted_zone ? 0 : 1
  name  = var.domain
  tags = {
    Name        = "${terraform.workspace}-lb-${var.ecs_cluster_name}"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

data "aws_route53_zone" "ndr_zone" {
  name  = var.domain
  count = var.using_arf_hosted_zone ? 1 : 0
}

resource "aws_route53_record" "ndr_fargate_record" {
  name    = "${terraform.workspace}.${var.sub_domain}"
  type    = "CNAME"
  records = ["${terraform.workspace}.${var.domain}"]
  zone_id = var.using_arf_hosted_zone ? data.aws_route53_zone.ndr_zone[0].zone_id : aws_route53_zone.ndr_zone[0].zone_id
  ttl     = 300
}

resource "aws_lb" "ecs_lb" {
  name               = "${terraform.workspace}-lb-${var.ecs_cluster_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ndr_ecs_sg.id]
  subnets            = [for subnet in var.public_subnets : subnet]

  tags = {
    Name        = "${terraform.workspace}-lb-${var.ecs_cluster_name}"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

resource "aws_lb_target_group" "ecs_lb_tg" {
  name        = "${terraform.workspace}-ecs"
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
    Name        = "lb_target_group-${var.ecs_cluster_name}"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.amazon_issued.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_lb_tg.arn
  }
}

data "aws_acm_certificate" "amazon_issued" {
  domain      = var.domain
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    target_group_arn = aws_lb_target_group.ecs_lb_tg.arn
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
