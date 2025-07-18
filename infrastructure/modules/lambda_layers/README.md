# Lambda Layer Module

## Features

- Creates a Lambda Layer version from a placeholder ZIP archive
- IAM policy for cross-role access to the layer
- Outputs layer ARN and policy ARN

---

## Usage

```hcl
module "lambda_layer" {
  source = "./modules/lambda-layer"

  # Required: AWS Account ID used in IAM policy generation
  account_id = "123456789012"

  # Required: Logical name for the Lambda Layer
  layer_name = "shared-utils"

  # Optional: Path to the zip file (relative to Terraform root)
  layer_zip_file_name = "shared-utils.zip"
}


```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Usage
Basic usage of this module is as follows:

```hcl
module "example" {
  	source = "<module-path>"
  
	# Required variables
  	account_id = 
  	layer_name = 
  
	# Optional variables
  	layer_zip_file_name = "placeholder_lambda_payload.zip"
}
```

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.lambda_layer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_lambda_layer_version.lambda_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [archive_file.lambda_layer_placeholder](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | n/a | `string` | n/a | yes |
| <a name="input_layer_name"></a> [layer\_name](#input\_layer\_name) | n/a | `string` | n/a | yes |
| <a name="input_layer_zip_file_name"></a> [layer\_zip\_file\_name](#input\_layer\_zip\_file\_name) | n/a | `string` | `"placeholder_lambda_payload.zip"` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_layer_arn"></a> [lambda\_layer\_arn](#output\_lambda\_layer\_arn) | Outputs |
| <a name="output_lambda_layer_policy_arn"></a> [lambda\_layer\_policy\_arn](#output\_lambda\_layer\_policy\_arn) | n/a |
<!-- END_TF_DOCS -->
