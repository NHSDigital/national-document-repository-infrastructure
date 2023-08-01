## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_method.proxy_method](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_resource.gateway_resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_gateway_id"></a> [api\_gateway\_id](#input\_api\_gateway\_id) | n/a | `string` | n/a | yes |
| <a name="input_authorization"></a> [authorization](#input\_authorization) | n/a | `string` | n/a | yes |
| <a name="input_authorizer_id"></a> [authorizer\_id](#input\_authorizer\_id) | n/a | `string` | n/a | yes |
| <a name="input_gateway_path"></a> [gateway\_path](#input\_gateway\_path) | n/a | `string` | n/a | yes |
| <a name="input_http_method"></a> [http\_method](#input\_http\_method) | n/a | `string` | n/a | yes |
| <a name="input_lambda_uri"></a> [lambda\_uri](#input\_lambda\_uri) | n/a | `string` | n/a | yes |
| <a name="input_parent_id"></a> [parent\_id](#input\_parent\_id) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
