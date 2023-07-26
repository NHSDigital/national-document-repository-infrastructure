resource "aws_vpc" "vpc" {
  cidr_block = vars.vpc_cidr
  enable_dns_support = vars.enable_dns_support
  enable_dns_hostnames = vars.enable_dns_hostnames
  name="ndr-vpc"
  tags = {
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

