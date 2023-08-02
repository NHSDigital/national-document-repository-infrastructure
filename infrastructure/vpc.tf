module "ndr-vpc-ui" {
  source = "./modules/vpc/"

  azs                   = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  enable_private_routes = false
  enable_dns_support    = true
  enable_dns_hostnames  = true
  num_public_subnets    = var.num_public_subnets
  num_private_subnets   = var.num_private_subnets

  environment = var.environment
  owner       = var.owner
}
