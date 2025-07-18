````

# VPC Networking Module with Subnets, Routing, and VPC Endpoints

This Terraform module provisions a VPC with public and private subnets, internet/NAT gateways, route tables, and optional VPC interface and gateway endpoints. It is designed for reusable infrastructure in staging or production environments with support for shared or standalone deployments.

---

## Features

- [x] VPC creation with custom CIDR block
- [x] Public and private subnet creation across multiple AZs
- [x] Internet Gateway (IGW) and NAT Gateway setup
- [x] Public and private route tables with associations
- [x] Optional VPC interface and gateway endpoints (e.g., S3, CloudWatch)
- [x] Optional standalone mode using pre-created VPC/IGW via tags
- [x] Tags applied by environment and owner

---

## Usage

```hcl
module "vpc" {
  source = "./modules/network"

  # Required: Custom tags
  environment = "prod"
  owner       = "platform"

  # Required: Number of public and private subnets to create
  num_public_subnets  = 2
  num_private_subnets = 2

  # Required: AZs to spread subnets across
  availability_zones = ["eu-west-2a", "eu-west-2b"]

  # Required: Services for VPC endpoints (interface and gateway)
  endpoint_interface_services = ["ecr.api", "logs"]
  endpoint_gateway_services   = ["s3"]

  # Required: Security group to associate with VPC endpoints
  security_group_id = aws_security_group.vpc_default.id

  # Required: Tags to find existing standalone VPC and IGW (when applicable)
  standalone_vpc_tag     = "shared-vpc"
  standalone_vpc_ig_tag  = "shared-igw"

  # Optional: VPC CIDR block
  vpc_cidr = "10.1.0.0/16"

  # Optional: Route control
  enable_private_routes = true

  # Optional: DNS settings
  enable_dns_support   = true
  enable_dns_hostnames = true
}


````

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                   | Version |
| ------------------------------------------------------ | ------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | ~> 5.0  |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | ~> 5.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                       | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [aws_default_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group)   | resource    |
| [aws_eip.eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)                                             | resource    |
| [aws_internet_gateway.ig](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)                    | resource    |
| [aws_nat_gateway.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway)                          | resource    |
| [aws_route.nat_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)                                   | resource    |
| [aws_route.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)                                     | resource    |
| [aws_route.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)                                      | resource    |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                         | resource    |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                          | resource    |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource    |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)  | resource    |
| [aws_subnet.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                           | resource    |
| [aws_subnet.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                            | resource    |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)                                             | resource    |
| [aws_vpc_endpoint.ndr_gateway_vpc_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint)      | resource    |
| [aws_vpc_endpoint.ndr_interface_vpc_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint)    | resource    |
| [aws_internet_gateway.ig](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/internet_gateway)                 | data source |
| [aws_subnet.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet)                        | data source |
| [aws_subnet.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet)                         | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc)                                          | data source |

## Inputs

| Name                                                                                                               | Description                                                                                                                                | Type           | Default         | Required |
| ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------ | -------------- | --------------- | :------: |
| <a name="input_availability_zones"></a> [availability_zones](#input_availability_zones)                            | This is a list that specifies all the Availability Zones that will have a pair of public and private subnets                               | `list(string)` | n/a             |   yes    |
| <a name="input_enable_dns_hostnames"></a> [enable_dns_hostnames](#input_enable_dns_hostnames)                      | This allows AWS DNS hostname support to be switched on or off.                                                                             | `bool`         | `true`          |    no    |
| <a name="input_enable_dns_support"></a> [enable_dns_support](#input_enable_dns_support)                            | This allows AWS DNS support to be switched on or off.                                                                                      | `bool`         | `true`          |    no    |
| <a name="input_enable_private_routes"></a> [enable_private_routes](#input_enable_private_routes)                   | n/a                                                                                                                                        | `bool`         | `false`         |    no    |
| <a name="input_endpoint_gateway_services"></a> [endpoint_gateway_services](#input_endpoint_gateway_services)       | n/a                                                                                                                                        | `list(string)` | n/a             |   yes    |
| <a name="input_endpoint_interface_services"></a> [endpoint_interface_services](#input_endpoint_interface_services) | n/a                                                                                                                                        | `list(string)` | n/a             |   yes    |
| <a name="input_environment"></a> [environment](#input_environment)                                                 | Tags                                                                                                                                       | `string`       | n/a             |   yes    |
| <a name="input_ig_cidr"></a> [ig_cidr](#input_ig_cidr)                                                             | This specifies the CIDR block for the internet gateway.                                                                                    | `string`       | `"0.0.0.0/0"`   |    no    |
| <a name="input_ig_ipv6_cidr"></a> [ig_ipv6_cidr](#input_ig_ipv6_cidr)                                              | This specifies the IPV6 CIDR block for the internet gateway.                                                                               | `string`       | `"::/0"`        |    no    |
| <a name="input_num_private_subnets"></a> [num_private_subnets](#input_num_private_subnets)                         | n/a                                                                                                                                        | `number`       | n/a             |   yes    |
| <a name="input_num_public_subnets"></a> [num_public_subnets](#input_num_public_subnets)                            | n/a                                                                                                                                        | `number`       | n/a             |   yes    |
| <a name="input_owner"></a> [owner](#input_owner)                                                                   | n/a                                                                                                                                        | `string`       | n/a             |   yes    |
| <a name="input_security_group_id"></a> [security_group_id](#input_security_group_id)                               | n/a                                                                                                                                        | `any`          | n/a             |   yes    |
| <a name="input_standalone_vpc_ig_tag"></a> [standalone_vpc_ig_tag](#input_standalone_vpc_ig_tag)                   | This is the tag assigned to the standalone vpc internet gateway that should be created manaully before the first run of the infrastructure | `string`       | n/a             |   yes    |
| <a name="input_standalone_vpc_tag"></a> [standalone_vpc_tag](#input_standalone_vpc_tag)                            | This is the tag assigned to the standalone vpc that should be created manaully before the first run of the infrastructure                  | `string`       | n/a             |   yes    |
| <a name="input_vpc_cidr"></a> [vpc_cidr](#input_vpc_cidr)                                                          | This specifices the VPC CIDR block                                                                                                         | `string`       | `"10.0.0.0/16"` |    no    |

## Outputs

<<<<<<< HEAD
| Name | Description |
|------|-------------|
| <a name="output_internet_gateway_id"></a> [internet_gateway_id](#output_internet_gateway_id) | n/a |
| <a name="output_private_subnets"></a> [private_subnets](#output_private_subnets) | n/a |
| <a name="output_public_subnets"></a> [public_subnets](#output_public_subnets) | n/a |
| <a name="output_vpc_id"></a> [vpc_id](#output_vpc_id) | n/a |
=======
| Name | Description |
| -------------------------------------------------------------------------------- | ----------- |
| <a name="output_private_subnets"></a> [private_subnets](#output_private_subnets) | n/a |
| <a name="output_public_subnets"></a> [public_subnets](#output_public_subnets) | n/a |
| <a name="output_vpc_id"></a> [vpc_id](#output_vpc_id) | n/a |

<!-- END_TF_DOCS -->

> > > > > > > 2b15286 (inject + cloudfront doc'+ begin/end)
