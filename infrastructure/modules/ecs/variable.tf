variable "vpc_id" {
  type        = string
  description = "ID of the VPC to deploy into"
}

variable "sg_name" {
  type        = string
  description = "Name for the security group"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster to deploy into"
}

variable "ecs_cluster_service_name" {
  type        = string
  description = "Name of the ECS service inside the cluster"
}

variable "ecs_launch_type" {
  type        = string
  description = "ECS launch type (e.g., FARGATE or EC2)"
  default     = "FARGATE"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet IDs"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "environment" {
  type        = string
  description = "Deployment environment tag used for naming and labeling (e.g., dev, prod)"
}

variable "owner" {
  type        = string
  description = "Identifies the team or person responsible for the resource (used for tagging)"
}

variable "ecr_repository_url" {
  type        = string
  description = "URL of the ECR repository to pull images from"
}

variable "domain" {
  type        = string
  description = "Used to set base level domain"
  default     = ""
}

variable "certificate_domain" {
  type        = string
  description = "The full domain name used to request the SSL/TLS certificate (e.g. 'example.com' or 'dev.example.com')."
  default     = ""
}

variable "container_port" {
  type        = number
  description = "Port number that the container listens on"
  default     = 8080
}

variable "alarm_actions_arn_list" {
  type = list(string)
}

variable "logs_bucket" {
}

variable "desired_count" {
  type    = number
  default = 3
}

variable "autoscaling_min_capacity" {
  type    = number
  default = 3
}

variable "autoscaling_max_capacity" {
  type    = number
  default = 6
}

variable "is_lb_needed" {
  type    = bool
  default = false
}

variable "is_service_needed" {
  type    = bool
  default = true
}

variable "is_autoscaling_needed" {
  type    = bool
  default = true
}

variable "environment_vars" {
  default = [null]
}

variable "ecs_task_definition_memory" {
  default = 2048
  type    = number
}

variable "ecs_task_definition_cpu" {
  default = 1024
  type    = number
}

variable "ecs_container_definition_memory" {
  default = 1024
  type    = number
}

variable "ecs_container_definition_cpu" {
  default = 512
  type    = number
}

variable "task_role" {
  default = null
}

locals {
  is_sandbox    = contains(["ndra", "ndrb", "ndrc", "ndrd"], terraform.workspace)
  is_production = contains(["prod", "pre-prod", "production"], terraform.workspace)
}

