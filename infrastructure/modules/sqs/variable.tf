variable "name" {
  type = string
}
variable "delay" {
  type    = number
  default = 0
}
variable "max_visibility" {
  type    = number
  default = 30
}
variable "max_message" {
  type    = number
  default = 2048
}
variable "message_retention" {
  type    = number
  default = 86400
}
variable "receive_wait" {
  type    = number
  default = 2
}
variable "enable_sse" {
  type    = bool
  default = true
}