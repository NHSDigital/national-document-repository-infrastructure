variable "vpc_id" {
  type = string
}

variable "sg_name" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_cluster_service_name" {
  type = string
}

variable "ecs_launch_type" {
  type    = string
  default = "FARGATE"
}

variable "public_subnets" {
}

variable "private_subnets" {
}

variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

variable "ecr_repository_url" {
}

variable "domain" {
  type = string
}

variable "certificate_domain" {
  type = string
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "alarm_actions_arn_list" {
  type = list(string)
}

locals {
  is_sandbox = contains(["ndra", "ndrb", "ndrc", "ndrd"], terraform.workspace)
}