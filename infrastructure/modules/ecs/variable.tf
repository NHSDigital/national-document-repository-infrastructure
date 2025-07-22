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
  type        = list(string)
  description = "List of ARNs for actions to trigger when CloudWatch alarms enter ALARM state"
}

variable "logs_bucket" {
  type        = string
  description = "Name of the S3 bucket to send logs to"
}

variable "desired_count" {
  type        = number
  description = "Number of ECS tasks to run by default"
  default     = 3
}

variable "autoscaling_min_capacity" {
  type        = number
  description = "Minimum number of ECS tasks to maintain when autoscaling is enabled"
  default     = 3
}

variable "autoscaling_max_capacity" {
  type        = number
  description = "Maximum number of ECS tasks allowed when autoscaling is enabled"
  default     = 6
}

variable "is_lb_needed" {
  type        = bool
  description = "Whether a Load Balancer is required for this service"
  default     = false
}

variable "is_service_needed" {
  type        = bool
  description = "Whether to create the ECS service resource"
  default     = true
}

variable "is_autoscaling_needed" {
  type        = bool
  description = "Whether to enable autoscaling for the ECS service"
  default     = true
}

variable "environment_vars" {
  description = "Environment variables to set for the ECS container definition"
  type        = list(any)
  default     = [null]
}

variable "ecs_task_definition_memory" {
  default     = 2048
  description = "Amount of memory (in MiB) to allocate to the ECS task definition"
  type        = number
}

variable "ecs_task_definition_cpu" {
  default     = 1024
  description = "Amount of CPU units to allocate to the ECS task definition"
  type        = number
}

variable "ecs_container_definition_memory" {
  default     = 1024
  description = "Amount of memory (in MiB) to allocate to the ECS container"
  type        = number
}

variable "ecs_container_definition_cpu" {
  default     = 512
  description = "Amount of CPU units to allocate to the ECS container"
  type        = number
}

variable "task_role" {
  default     = null
  description = "IAM role ARN to associate with the ECS task"
}

locals {
  is_sandbox    = contains(["ndra", "ndrb", "ndrc", "ndrd"], terraform.workspace)
  is_production = contains(["prod", "pre-prod", "production"], terraform.workspace)
}

