locals {
  num_az_zones = length(var.azs)
}

locals {
  public_subnet_cidrs  = [for i in range(1, var.num_public_subnets + 1) : "10.0.${i}.0/24"]
  private_subnet_cidrs = [for i in range(1, var.num_private_subnets + 1) : "10.0.10${i}.0/24"]
}
