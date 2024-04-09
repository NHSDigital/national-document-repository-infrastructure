output "vpc_id" {
  value = local.is_production ? aws_vpc.vpc[0].id : data.aws_vpc.vpc[0].id
}

output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnets" {
  value = aws_subnet.private_subnets.*.id
}
