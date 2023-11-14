output "dns_name" {
  value = aws_lb.ecs_lb.dns_name
}

output "security_group_id" {
  value = aws_security_group.ndr_ecs_sg.id
}

output "load_balancer_arn" {
  description = "The arn of the load balancer"
  value       = aws_lb.ecs_lb.arn
}