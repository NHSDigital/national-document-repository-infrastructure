module "ndr-docker-ecr-ui" {
  source   = "./modules/ecr/"
  app_name = "ndr-${terraform.workspace}-app"

  environment = var.environment
  owner       = var.owner
}
module "ndr-docker-ecr-weekly-ods-update" {
  source   = "./modules/ecr/"
  app_name = "${terraform.workspace}-weekly-ods-update"

  environment = var.environment
  owner       = var.owner
}
