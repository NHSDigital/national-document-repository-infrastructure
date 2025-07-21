variable "environment" {
  type        = string
  description = "Deployment environment tag used for naming and labeling (e.g., dev, prod)"
}

variable "owner" {
  type        = string
  description = "Identifies the team or person responsible for the resource (used for tagging)."
}

variable "config_environment_name" {
  type        = string
  description = "Name of the AppConfig environment (e.g., dev, prod)."
}

variable "config_profile_name" {
  type        = string
  description = "Name of the AppConfig configuration profile."
}


