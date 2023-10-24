terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "vpc" {
  tags = {
    Name = "${terraform.workspace}-vpc"
  }
}

resource "aws_subnet" "virus_scanning_subnet1" {
  availability_zone = "eu-west-2a"
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = "10.0.64.0/24"

  tags = {
    Name = "Virus scanning subnet for eu-west-2a"
    Environment = var.environment
    Owner = var.owner
  }
}

resource "aws_subnet" "virus_scanning_subnet2" {
  availability_zone = "eu-west-2b"
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = "10.0.128.0/24"

  tags = {
    Name = "Virus scanning subnet for eu-west-2b"
    Environment = var.environment
    Owner = var.owner
  }
}

data "aws_internet_gateway" "ig" {
  tags = {
    Name = "${terraform.workspace}-vpc-internet-gateway"
  }
}

resource "aws_route_table" "virus_scanning_route_table" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.ig.id
  }

  tags = {
    Name = "Virus scanning route table"
    Environment = var.environment
    Owner = var.owner
  }
}

resource "aws_route_table_association" "virus_scanning_subnet1_route_table_association" {
  subnet_id      = aws_subnet.virus_scanning_subnet1.id
  route_table_id = aws_route_table.virus_scanning_route_table.id
}

resource "aws_route_table_association" "virus_scanning_subnet2_route_table_association" {
  subnet_id      = aws_subnet.virus_scanning_subnet2.id
  route_table_id = aws_route_table.virus_scanning_route_table.id
}

data "aws_ssm_parameter" "cloud_security_admin_email" {
  name = "/prs/${var.environment}/user-input/cloud-security-admin-email"
}

resource "aws_cloudformation_stack" "s3_virus_scanning_stack" {
  name = "s3-virus-scanning-cloudformation-stack"
  parameters = {
    VPC                                = data.aws_vpc.vpc.id
    SubnetA                            = aws_subnet.virus_scanning_subnet1.id
    SubnetB                            = aws_subnet.virus_scanning_subnet2.id
    ConsoleSecurityGroupCidrBlock      = var.black_hole_address
    Email                              = data.aws_ssm_parameter.cloud_security_admin_email.value
    OnlyScanWhenQueueThresholdExceeded = "Yes"
    MinRunningAgents                   = 0
    NumMessagesInQueueScalingThreshold = 1
    AllowAccessToAllKmsKeys            = "No"
  }
  timeouts {
    create = "60m"
    delete = "2h"
  }
  tags = {
    Name = "Virus scanner for Repository"
    Environment = var.environment
    Owner = var.owner
  }
  template_url = "https://css-cft.s3.amazonaws.com/ConsoleCloudFormationTemplate.yaml"
  capabilities = ["CAPABILITY_NAMED_IAM"]
}
