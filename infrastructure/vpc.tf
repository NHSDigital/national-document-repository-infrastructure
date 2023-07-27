module "ndr-vpc-ui" {
  source = "./modules/vpc/"

  enable_private_routes = false
  enable_dns_support    = true
  enable_dns_hostnames  = true
}
