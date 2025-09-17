module "ndr-docker-ecr-ui" {
  source              = "./modules/ecr/"
  app_name            = "ndr-${terraform.workspace}-app"
  allow_force_destroy = local.is_force_destroy

  environment = var.environment
  owner       = var.owner
}

module "ndr-docker-ecr-data-collection" {
  count               = 1
  source              = "./modules/ecr/"
  app_name            = "${terraform.workspace}-data-collection"
  allow_force_destroy = local.is_force_destroy

  environment = var.environment
  owner       = var.owner
}
