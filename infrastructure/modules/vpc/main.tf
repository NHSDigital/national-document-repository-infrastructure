resource "aws_vpc" "vpc" {
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

resource "aws_subnet" "public_subnets" {
  count             = local.num_public_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(local.public_subnet_cidrs, count.index)
  availability_zone = element(local.az_zones, count.index)
  tags = {
    Name        = "${terraform.workspace}-public-subnet-${count.index + 1}"
    Zone        = "Public"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

resource "aws_subnet" "private_subnets" {
  count             = local.num_private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(local.private_subnet_cidrs, count.index)
  availability_zone = element(local.az_zones, count.index)
  tags = {
    Name        = "${terraform.workspace}-private-subnet-${count.index + 1}"
    Zone        = "Private"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

resource "aws_internet_gateway" "ig" {
  count  = local.num_public_subnets > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${terraform.workspace}-vpc-internet-gateway"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace

  }
}

resource "aws_route_table" "public" {
  count  = local.num_public_subnets > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${terraform.workspace}-public-route-table"
    Zone        = "Public"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace

  }
}

resource "aws_route_table" "private" {
  count  = local.num_private_subnets > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${terraform.workspace}-private-route-table"
    Zone        = "Private"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace

  }
}

resource "aws_route" "public" {
  count                  = local.num_public_subnets > 0 ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = var.ig_cidr
  gateway_id             = aws_internet_gateway.ig[0].id
}

resource "aws_route" "private" {
  count                       = (local.num_private_subnets > 0) && var.enable_private_routes ? 1 : 0
  route_table_id              = aws_route_table.private[0].id
  destination_ipv6_cidr_block = var.ig_ipv6_cidr
  gateway_id                  = aws_internet_gateway.ig[0].id

}

resource "aws_route_table_association" "public" {
  count          = local.num_public_subnets
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table_association" "private" {
  count          = local.num_private_subnets
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private[0].id
}
