data "aws_vpc" "vpc" {
  count = local.is_production ? 0 : 1
  tags = {
    Name = var.standalone_vpc_tag
  }
}

resource "aws_vpc" "vpc" {
  count                = local.is_production ? 1 : 0
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name        = "${terraform.workspace}-vpc"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

resource "aws_internet_gateway" "ig" {
  count  = var.num_public_subnets > 0 ? 1 : 0
  vpc_id = local.is_production ? aws_vpc.vpc[0].id : data.aws_vpc.vpc[0].id
  tags = {
    Name        = "${terraform.workspace}-vpc-internet-gateway"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace

  }
}

resource "aws_vpc_endpoint" "ndr_gateway_vpc_endpoint" {
  count           = length(var.endpoint_gateway_services)
  vpc_id          = local.is_production ? aws_vpc.vpc[0].id : data.aws_vpc.vpc[0].id
  service_name    = "com.amazonaws.eu-west-2.${var.endpoint_gateway_services[count.index]}"
  route_table_ids = [aws_route_table.private[0].id]
  tags = {
    Name        = "${terraform.workspace}-${var.endpoint_gateway_services[count.index]}-vpc"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

resource "aws_vpc_endpoint" "ndr_interface_vpc_endpoint" {
  count               = length(var.endpoint_interface_services)
  vpc_id              = local.is_production ? aws_vpc.vpc[0].id : data.aws_vpc.vpc[0].id
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [var.security_group_id]
  private_dns_enabled = true
  subnet_ids          = [for subnet in aws_subnet.private_subnets : subnet.id]

  service_name = "com.amazonaws.eu-west-2.${var.endpoint_interface_services[count.index]}"
  tags = {
    Name        = "${terraform.workspace}-${var.endpoint_interface_services[count.index]}-vpc"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

