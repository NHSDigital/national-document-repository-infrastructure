## Requirements

| Name                                                   | Version |
| ------------------------------------------------------ | ------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | >= 4.0  |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | 5.16.0  |

## Modules

<<<<<<< HEAD
| Name                                                                                                                                               | Source                  | Version |
| -------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- | ------- |
| <a name="module_api_endpoint_url_ssm_parameter"></a> [api_endpoint_url_ssm_parameter](#module_api_endpoint_url_ssm_parameter)                      | ./modules/ssm_parameter | n/a     |
| <a name="module_create-doc-ref-gateway"></a> [create-doc-ref-gateway](#module_create-doc-ref-gateway)                                              | ./modules/gateway       | n/a     |
| <a name="module_create-doc-ref-lambda"></a> [create-doc-ref-lambda](#module_create-doc-ref-lambda)                                                 | ./modules/lambda        | n/a     |
| <a name="module_document_reference_dynamodb_table"></a> [document_reference_dynamodb_table](#module_document_reference_dynamodb_table)             | ./modules/dynamo_db     | n/a     |
| <a name="module_lloyd_george_reference_dynamodb_table"></a> [lloyd_george_reference_dynamodb_table](#module_lloyd_george_reference_dynamodb_table) | ./modules/dynamo_db     | n/a     |
| <a name="module_ndr-docker-ecr-ui"></a> [ndr-docker-ecr-ui](#module_ndr-docker-ecr-ui)                                                             | ./modules/ecr/          | n/a     |
| <a name="module_ndr-document-store"></a> [ndr-document-store](#module_ndr-document-store)                                                          | ./modules/s3/           | n/a     |
| <a name="module_ndr-ecs-fargate"></a> [ndr-ecs-fargate](#module_ndr-ecs-fargate)                                                                   | ./modules/ecs           | n/a     |
| <a name="module_ndr-lloyd-george-store"></a> [ndr-lloyd-george-store](#module_ndr-lloyd-george-store)                                              | ./modules/s3/           | n/a     |
| <a name="module_ndr-vpc-ui"></a> [ndr-vpc-ui](#module_ndr-vpc-ui)                                                                                  | ./modules/vpc/          | n/a     |
| <a name="module_ndr-zip-request-store"></a> [ndr-zip-request-store](#module_ndr-zip-request-store)                                                 | ./modules/s3/           | n/a     |
| <a name="module_route53_fargate_ui"></a> [route53_fargate_ui](#module_route53_fargate_ui)                                                          | ./modules/route53       | n/a     |
| <a name="module_search-document-references-gateway"></a> [search-document-references-gateway](#module_search-document-references-gateway)          | ./modules/gateway       | n/a     |
| <a name="module_search-document-references-lambda"></a> [search-document-references-lambda](#module_search-document-references-lambda)             | ./modules/lambda        | n/a     |
| <a name="module_search-patient-details-gateway"></a> [search-patient-details-gateway](#module_search-patient-details-gateway)                      | ./modules/gateway       | n/a     |
| <a name="module_search-patient-details-lambda"></a> [search-patient-details-lambda](#module_search-patient-details-lambda)                         | ./modules/lambda        | n/a     |
| <a name="module_sqs-splunk-queue"></a> [sqs-splunk-queue](#module_sqs-splunk-queue)                                                                | ./modules/sqs           | n/a     |
| <a name="module_zip_store_reference_dynamodb_table"></a> [zip_store_reference_dynamodb_table](#module_zip_store_reference_dynamodb_table)          | ./modules/dynamo_db     | n/a     |
=======
| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_endpoint_url_ssm_parameter"></a> [api\_endpoint\_url\_ssm\_parameter](#module\_api\_endpoint\_url\_ssm\_parameter) | ./modules/ssm_parameter | n/a |
| <a name="module_create-doc-ref-gateway"></a> [create-doc-ref-gateway](#module\_create-doc-ref-gateway) | ./modules/gateway | n/a |
| <a name="module_create-doc-ref-lambda"></a> [create-doc-ref-lambda](#module\_create-doc-ref-lambda) | ./modules/lambda | n/a |
| <a name="module_document_reference_dynamodb_table"></a> [document\_reference\_dynamodb\_table](#module\_document\_reference\_dynamodb\_table) | ./modules/dynamo_db | n/a |
| <a name="module_lloyd_george_reference_dynamodb_table"></a> [lloyd\_george\_reference\_dynamodb\_table](#module\_lloyd\_george\_reference\_dynamodb\_table) | ./modules/dynamo_db | n/a |
| <a name="module_ndr-docker-ecr-ui"></a> [ndr-docker-ecr-ui](#module\_ndr-docker-ecr-ui) | ./modules/ecr/ | n/a |
| <a name="module_ndr-document-store"></a> [ndr-document-store](#module\_ndr-document-store) | ./modules/s3/ | n/a |
| <a name="module_ndr-ecs-fargate"></a> [ndr-ecs-fargate](#module\_ndr-ecs-fargate) | ./modules/ecs | n/a |
| <a name="module_ndr-lloyd-george-store"></a> [ndr-lloyd-george-store](#module\_ndr-lloyd-george-store) | ./modules/s3/ | n/a |
| <a name="module_ndr-vpc-ui"></a> [ndr-vpc-ui](#module\_ndr-vpc-ui) | ./modules/vpc/ | n/a |
| <a name="module_ndr-zip-request-store"></a> [ndr-zip-request-store](#module\_ndr-zip-request-store) | ./modules/s3/ | n/a |
| <a name="module_route53_fargate_ui"></a> [route53\_fargate\_ui](#module\_route53\_fargate\_ui) | ./modules/route53 | n/a |
| <a name="module_search-document-references-gateway"></a> [search-document-references-gateway](#module\_search-document-references-gateway) | ./modules/gateway | n/a |
| <a name="module_search-document-references-lambda"></a> [search-document-references-lambda](#module\_search-document-references-lambda) | ./modules/lambda | n/a |
| <a name="module_search-patient-details-gateway"></a> [search-patient-details-gateway](#module\_search-patient-details-gateway) | ./modules/gateway | n/a |
| <a name="module_search-patient-details-lambda"></a> [search-patient-details-lambda](#module\_search-patient-details-lambda) | ./modules/lambda | n/a |
| <a name="module_zip_store_reference_dynamodb_table"></a> [zip\_store\_reference\_dynamodb\_table](#module\_zip\_store\_reference\_dynamodb\_table) | ./modules/dynamo_db | n/a |
>>>>>>> 5dcccee (Add sns readmes)

## Resources

| Name                                                                                                                                                               | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [aws_api_gateway_deployment.ndr_api_deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment)                    | resource    |
| [aws_api_gateway_gateway_response.bad_gateway_response](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_gateway_response)  | resource    |
| [aws_api_gateway_gateway_response.unauthorised_response](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_gateway_response) | resource    |
| [aws_api_gateway_rest_api.ndr_doc_store_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api)                     | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                      | data source |

## Inputs

| Name                                                                                                                              | Description                                                                                                  | Type           | Default                                                                | Required |
| --------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ | -------------- | ---------------------------------------------------------------------- | :------: |
| <a name="input_availability_zones"></a> [availability_zones](#input_availability_zones)                                           | This is a list that specifies all the Availability Zones that will have a pair of public and private subnets | `list(string)` | <pre>[<br> "eu-west-2a",<br> "eu-west-2b",<br> "eu-west-2c"<br>]</pre> |    no    |
| <a name="input_cors_require_credentials"></a> [cors_require_credentials](#input_cors_require_credentials)                         | Sets the value of 'Access-Control-Allow-Credentials' which controls whether auth cookies are needed          | `bool`         | `true`                                                                 |    no    |
| <a name="input_docstore_bucket_name"></a> [docstore_bucket_name](#input_docstore_bucket_name)                                     | Bucket Variables                                                                                             | `string`       | `"document-store"`                                                     |    no    |
| <a name="input_docstore_dynamodb_table_name"></a> [docstore_dynamodb_table_name](#input_docstore_dynamodb_table_name)             | DynamoDB Table Variables                                                                                     | `string`       | `"DocumentReferenceMetadata"`                                          |    no    |
| <a name="input_domain"></a> [domain](#input_domain)                                                                               | n/a                                                                                                          | `string`       | n/a                                                                    |   yes    |
| <a name="input_enable_dns_hostnames"></a> [enable_dns_hostnames](#input_enable_dns_hostnames)                                     | Enable DNS hostnames for VPC                                                                                 | `bool`         | `true`                                                                 |    no    |
| <a name="input_enable_dns_support"></a> [enable_dns_support](#input_enable_dns_support)                                           | Enable DNS support for VPC                                                                                   | `bool`         | `true`                                                                 |    no    |
| <a name="input_enable_private_routes"></a> [enable_private_routes](#input_enable_private_routes)                                  | Controls whether the internet gateway can connect to private subnets                                         | `bool`         | `false`                                                                |    no    |
| <a name="input_environment"></a> [environment](#input_environment)                                                                | Tag Variables                                                                                                | `string`       | n/a                                                                    |   yes    |
| <a name="input_lloyd_george_bucket_name"></a> [lloyd_george_bucket_name](#input_lloyd_george_bucket_name)                         | n/a                                                                                                          | `string`       | `"lloyd-george-store"`                                                 |    no    |
| <a name="input_lloyd_george_dynamodb_table_name"></a> [lloyd_george_dynamodb_table_name](#input_lloyd_george_dynamodb_table_name) | n/a                                                                                                          | `string`       | `"LloydGeorgeReferenceMetadata"`                                       |    no    |
| <a name="input_num_private_subnets"></a> [num_private_subnets](#input_num_private_subnets)                                        | Sets the number of private subnets, one per availability zone                                                | `number`       | `3`                                                                    |    no    |
| <a name="input_num_public_subnets"></a> [num_public_subnets](#input_num_public_subnets)                                           | Sets the number of public subnets, one per availability zone                                                 | `number`       | `3`                                                                    |    no    |
| <a name="input_owner"></a> [owner](#input_owner)                                                                                  | n/a                                                                                                          | `string`       | n/a                                                                    |   yes    |
| <a name="input_zip_store_bucket_name"></a> [zip_store_bucket_name](#input_zip_store_bucket_name)                                  | n/a                                                                                                          | `string`       | `"zip-request-store"`                                                  |    no    |
| <a name="input_zip_store_dynamodb_table_name"></a> [zip_store_dynamodb_table_name](#input_zip_store_dynamodb_table_name)          | n/a                                                                                                          | `string`       | `"ZipStoreReferenceMetadata"`                                          |    no    |

## Outputs

No outputs.
