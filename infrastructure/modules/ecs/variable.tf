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

# Tags

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}