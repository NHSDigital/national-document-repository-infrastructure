locals {
  lambda_layers = contains(var.persistent_workspaces, terraform.workspace) ? concat(var.default_lambda_layers, var.extra_lambda_layers) : var.default_lambda_layers
}
