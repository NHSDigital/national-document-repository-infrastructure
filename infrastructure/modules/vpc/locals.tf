locals {
  num_az_zones = length(var.azs)
  az_zones     = var.azs
}

locals {
  public_subnet_cidrs  = [for i in range(1, local.num_az_zones + 1) : "10.0.${i}.0/24"]
  private_subnet_cidrs = [for i in range(1, local.num_az_zones + 1) : "10.0.10${i}.0/24"]

  num_public_subnets  = length(local.public_subnet_cidrs)
  num_private_subnets = length(local.private_subnet_cidrs)
}
