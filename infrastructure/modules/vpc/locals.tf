locals {
  num_az_zones = length(var.azs) == 0 ? length(data.aws_availability_zones.available.names) : length(var.azs)

  az_zones = var.azs
}

locals {
  public_subnet_cidrs = var.num_public_subnets == -1 ? [for i in range(1, local.num_az_zones + 1) : "10.0.${i}.0/24"] : [for i in range(1, var.num_public_subnets + 1) : "10.0.${i}.0/24"]

  private_subnet_cidrs = var.num_private_subnets == -1 ? [for i in range(1, local.num_az_zones + 1) : "10.0.10${i}.0/24"] : [for i in range(1, var.num_private_subnets + 1) : "10.0.10${i}.0/24"]
}