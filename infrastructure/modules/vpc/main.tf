resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name        = "${terraform.workspace}-vpc"
    Environment = terraform.workspace
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(local.public_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(local.public_subnet_cidrs, count.index)
  availability_zone = element(local.az_zones, count.index)

  tags = {
    Name = "${terraform.workspace}-public-subnet-${count.index + 1}"
    Zone = "Public"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(local.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(local.private_subnet_cidrs, count.index)
  availability_zone = element(local.az_zones, count.index)

  tags = {
    Name = "${terraform.workspace}-private-subnet-${count.index + 1}"
    Zone = "Private"
  }
}

resource "aws_internet_gateway" "ig" {
  count  = length(local.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${terraform.workspace}-vpc-internet-gateway"
  }
}

resource "aws_route_table" "public" {
  count  = length(local.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${terraform.workspace}-public-route-table"
  }
}

resource "aws_route_table" "private" {
  count  = length(local.private_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id


  tags = {
    Name = "${terraform.workspace}-private-route-table"
  }
}

resource "aws_route" "public" {
  count                  = length(local.public_subnet_cidrs) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = var.ig_cidr
  gateway_id             = aws_internet_gateway.ig[0].id
}



resource "aws_route" "private" {
  count                       = (length(local.private_subnet_cidrs) > 0) && var.enable_private_routes ? 1 : 0
  route_table_id              = aws_route_table.private[0].id
  destination_ipv6_cidr_block = var.ig_ipv6_cidr
  gateway_id                  = aws_internet_gateway.ig[0].id

}


resource "aws_route_table_association" "public" {
  count          = length(local.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table_association" "private" {
  count          = length(local.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private[0].id
}
