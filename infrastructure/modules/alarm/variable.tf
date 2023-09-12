variable "alarm_name" {
  type = string
}

variable "alarm_description" {
  type = string
}

variable "namespace" {
  type = string
}

variable "api_name" {
  type = string
}

variable "metric_name" {
  type = string
}

variable "alarm_actions" {
  type = list(string)
}

variable "ok_actions" {
  type = list(string)
}