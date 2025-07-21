variable "app_name" {
  description = " Name of the application (used in repository naming)"
  type        = string
}

variable "environment" {
  type        = string
  description = "Deployment environment tag used for naming and labeling (e.g., dev, prod)"
}

variable "owner" {
  type        = string
  description = "Identifies the team or person responsible for the resource (used for tagging)"
}

variable "current_account_id" {
  type        = string
  description = "AWS account ID where the repository is created"
}
