## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.9.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_create-doc-ref-gateway"></a> [create-doc-ref-gateway](#module\_create-doc-ref-gateway) | ./modules/gateway | n/a |
| <a name="module_ndr-document-store"></a> [ndr-document-store](#module\_ndr-document-store) | ./modules/s3/ | n/a |
| <a name="module_ndr-vpc-ui"></a> [ndr-vpc-ui](#module\_ndr-vpc-ui) | ./modules/vpc/ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_deployment.ndr_api_deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_gateway_response.bad_gateway_response](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_gateway_response) | resource |
| [aws_api_gateway_gateway_response.unauthorised_response](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_gateway_response) | resource |
| [aws_api_gateway_rest_api.ndr_docstore_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cors_require_credentials"></a> [cors\_require\_credentials](#input\_cors\_require\_credentials) | n/a | `bool` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_num_private_subnets"></a> [num\_private\_subnets](#input\_num\_private\_subnets) | n/a | `number` | `3` | no |
| <a name="input_num_public_subnets"></a> [num\_public\_subnets](#input\_num\_public\_subnets) | n/a | `number` | `3` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
