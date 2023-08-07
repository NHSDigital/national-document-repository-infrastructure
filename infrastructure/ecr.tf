module "ndr-docker-ui" {
  source   = "./modules/ecr/"
  app_name = "ndr-${terraform.workspace}-app"

  environment = var.environment
  owner       = var.owner
}