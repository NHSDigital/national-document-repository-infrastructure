module "ndr-docker-ecr-ui" {
  source              = "./modules/ecr/"
  app_name            = "ndr-${terraform.workspace}-app"
  allow_force_destroy = local.is_force_destroy

  environment = var.environment
  owner       = var.owner
}

module "ndr-docker-ecr-data-collection" {
  count               = local.is_sandbox ? 0 : 1
  source              = "./modules/ecr/"
  app_name            = "${terraform.workspace}-data-collection"
  allow_force_destroy = local.is_force_destroy

  environment = var.environment
  owner       = var.owner
}

module "ndr-docker-ecr-s3-data-collection" {
  count               = local.is_sandbox ? 0 : 1
  source              = "./modules/ecr/"
  app_name            = "${terraform.workspace}-s3-data-collection"
  allow_force_destroy = local.is_force_destroy

  environment = var.environment
  owner       = var.owner
}
