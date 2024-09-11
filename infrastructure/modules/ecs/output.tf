output "dns_name" {
  value = aws_lb.ecs_lb[0].dns_name
}

output "security_group_id" {
  value = aws_security_group.ndr_ecs_sg.id
}

output "load_balancer_arn" {
  description = "The arn of the load balancer"
  value       = aws_lb.ecs_lb[0].arn
}

output "certificate_arn" {
  description = "The arn of certificate that load balancer is using"
  value       = data.aws_acm_certificate.amazon_issued[0].arn
}

output "container_port" {
  description = "The container port number of docker image, which was provided as input variable of this module"
  value       = var.container_port
}