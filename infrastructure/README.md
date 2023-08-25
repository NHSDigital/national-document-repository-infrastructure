## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.13.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.13.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_create-doc-ref-gateway"></a> [create-doc-ref-gateway](#module\_create-doc-ref-gateway) | ./modules/gateway | n/a |
| <a name="module_create-doc-ref-lambda"></a> [create-doc-ref-lambda](#module\_create-doc-ref-lambda) | ./modules/lambda | n/a |
| <a name="module_document_reference_dynamodb_table"></a> [document\_reference\_dynamodb\_table](#module\_document\_reference\_dynamodb\_table) | ./modules/DynamoDB | n/a |
| <a name="module_ndr-docker-ecr-ui"></a> [ndr-docker-ecr-ui](#module\_ndr-docker-ecr-ui) | ./modules/ecr/ | n/a |
| <a name="module_ndr-document-store"></a> [ndr-document-store](#module\_ndr-document-store) | ./modules/s3/ | n/a |
| <a name="module_ndr-ecs-fargate"></a> [ndr-ecs-fargate](#module\_ndr-ecs-fargate) | ./modules/ecs | n/a |
| <a name="module_ndr-vpc-ui"></a> [ndr-vpc-ui](#module\_ndr-vpc-ui) | ./modules/vpc/ | n/a |
| <a name="module_route53_fargate_ui"></a> [route53\_fargate\_ui](#module\_route53\_fargate\_ui) | ./modules/route53 | n/a |
| <a name="module_search-document-references-gateway"></a> [search-document-references-gateway](#module\_search-document-references-gateway) | ./modules/gateway | n/a |
| <a name="module_search-document-references-lambda"></a> [search-document-references-lambda](#module\_search-document-references-lambda) | ./modules/lambda | n/a |
| <a name="module_search-patient-details-gateway"></a> [search-patient-details-gateway](#module\_search-patient-details-gateway) | ./modules/gateway | n/a |
| <a name="module_search-patient-details-lambda"></a> [search-patient-details-lambda](#module\_search-patient-details-lambda) | ./modules/lambda | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_deployment.ndr_api_deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_gateway_response.bad_gateway_response](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_gateway_response) | resource |
| [aws_api_gateway_gateway_response.unauthorised_response](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_gateway_response) | resource |
| [aws_api_gateway_rest_api.ndr_doc_store_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | This is a list that specifies all the Availability Zones that will have a pair of public and private subnets | `list(string)` | <pre>[<br>  "eu-west-2a",<br>  "eu-west-2b",<br>  "eu-west-2c"<br>]</pre> | no |
| <a name="input_cors_require_credentials"></a> [cors\_require\_credentials](#input\_cors\_require\_credentials) | Sets the value of 'Access-Control-Allow-Credentials' which controls whether auth cookies are needed | `bool` | `true` | no |
| <a name="input_docstore_bucket_name"></a> [docstore\_bucket\_name](#input\_docstore\_bucket\_name) | Bucket Variables | `string` | `"document-store"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable DNS hostnames for VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable DNS  support for VPC | `bool` | `true` | no |
| <a name="input_enable_private_routes"></a> [enable\_private\_routes](#input\_enable\_private\_routes) | Controls whether the internet gateway can connect to private subnets | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Tag Variables | `string` | n/a | yes |
| <a name="input_num_private_subnets"></a> [num\_private\_subnets](#input\_num\_private\_subnets) | Sets the number of private subnets, one per availability zone | `number` | `3` | no |
| <a name="input_num_public_subnets"></a> [num\_public\_subnets](#input\_num\_public\_subnets) | Sets the number of public subnets, one per availability zone | `number` | `3` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
