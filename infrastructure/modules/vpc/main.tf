resource "aws_vpc" "vpc" {
  cidr_block = vars.vpc_cidr
  enable_dns_support = vars.enable_dns_support
  enable_dns_hostnames = vars.enable_dns_hostnames
  name="ndr-vpc"
  tags = {
    Name  = "${terraform.workspace}-vpc"
    Environment = terraform.workspace
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.az_zones, count.index)

  tags = {
    Name  = "${terraform.workspace}-public-subnet-${count.index + 1}"
    Zone  = "Public"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.az_zones, count.index)

  tags = {
    Name  = "${terraform.workspace}-private-subnet-${count.index + 1}"
    Zone  = "Private"
  }
}

resource "aws_internet_gateway" "ig" {
  count  = length(local.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = {
        Name  = "${terraform.workspace}-vpc-internet-gateway"
  }
}

resource "aws_route_table" "route_table" {
  count  = length(local.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.ig_cidr
    gateway_id = aws_internet_gateway.ig[0].id
  }

  route {
    cidr_block = var.ig_ipv6_cidr
    gateway_id = aws_internet_gateway.ig[0].id
  }

  tags = {
    Name = "${terraform.workspace}-public-route-table"
  }
}