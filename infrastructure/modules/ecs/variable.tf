variable "vpc_id" {
  type = string
}

variable "sg_name" {
  type    = string
  default = null
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
  type    = string
  default = ""
}

variable "certificate_domain" {
  type    = string
  default = ""
}

variable "container_port" {
  type    = number
  default = 8080
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

