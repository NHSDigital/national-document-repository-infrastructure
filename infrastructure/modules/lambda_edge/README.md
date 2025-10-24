# Lambda Proxy for S3 Access Module

## Features

- Lambda function with:
  - Configurable timeout, memory, and ephemeral storage
  - Reserved concurrency support
- IAM role with support for user-supplied inline policies
- Outputs function name and ARNs for integration

---

## Usage

```hcl
module "s3_proxy_lambda" {
  source = "./modules/lambda-proxy"

  # Required: Unique name for the Lambda function
  name = "s3-proxy"

  # Required: Handler function in the code package (e.g., "index.handler")
  handler = "index.handler"

  # Required: Name of the target S3 bucket
  bucket_name = "my-app-assets"

  # Required: Name of the associated DynamoDB table (if applicable)
  table_name = "my-tracking-table"

  # Required: List of IAM policy ARNs or documents to attach to the role
  iam_role_policies = [
    data.aws_iam_policy_document.lambda_policy.json
  ]

  # Optional: Memory allocation in MB
  memory_size = 128

  # Optional: Ephemeral storage in MB
  lambda_ephemeral_storage = 512

  # Optional: Reserved concurrency (-1 = unlimited, 0 = disabled)
  reserved_concurrent_executions = -1
}


```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.combined_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_exec_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_exec_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.default_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [archive_file.lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.merged_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket the Lambda will proxy requests to. | `string` | n/a | yes |
| <a name="input_default_policies"></a> [default\_policies](#input\_default\_policies) | List of default IAM policy ARNs to attach to the Lambda execution role. | `list(string)` | <pre>[<br/>  "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"<br/>]</pre> | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Handler function in the code package (e.g., 'index.handler'). | `string` | n/a | yes |
| <a name="input_iam_role_policy_documents"></a> [iam\_role\_policy\_documents](#input\_iam\_role\_policy\_documents) | List of IAM policy document ARNs to attach to the Lambda execution role. | `list(string)` | `[]` | no |
| <a name="input_lambda_ephemeral_storage"></a> [lambda\_ephemeral\_storage](#input\_lambda\_ephemeral\_storage) | Amount of ephemeral storage (in MB) allocated to the Lambda function. | `number` | `512` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory (in MB) to allocate to the Lambda function. | `number` | `128` | no |
| <a name="input_name"></a> [name](#input\_name) | Unique name for the Lambda function. | `string` | n/a | yes |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | The number of concurrent execution allowed for lambda. A value of 0 will stop lambda from running, and -1 removes any concurrency limitations. Default to -1. | `number` | `-1` | no |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | The name of the DynamoDB table used by the Lambda function. | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | n/a |
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | n/a |
| <a name="output_qualified_arn"></a> [qualified\_arn](#output\_qualified\_arn) | n/a |
| <a name="output_timeout"></a> [timeout](#output\_timeout) | n/a |
<!-- END_TF_DOCS -->
