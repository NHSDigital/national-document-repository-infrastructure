# ECR Repository Module

This Terraform module provisions an AWS Elastic Container Registry (ECR) repository with lifecycle management, cross-account access policies, and tagging support. It enables secure, automated Docker image storage for modern CI/CD pipelines and container-based workloads.

---

## Features

- ECR repository with custom name derived from app and environment
- Lifecycle policy to clean up unused images automatically
- Cross-account access via repository policy
- Resource tagging with environment and owner
- Output of repository URL for use in pipelines or other modules

---

## Usage

```hcl
module "ecr_repository" {
  source = "./modules/ecr"

  # Required: Application name used to name the ECR repo
  app_name = "my-app"

  # Required: Environment tag for context (e.g., "dev", "prod")
  environment = "prod"

  # Required: Account ID for use in policy references
  current_account_id = "123456789012"

  # Required: Owner or team label for resource tagging
  owner = "platform"
}


```

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

| Name                                                                                                                                                     | Type     |
| -------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_ecr_lifecycle_policy.ndr_ecr_lifecycle_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy)    | resource |
| [aws_ecr_repository.ndr-ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository)                                 | resource |
| [aws_ecr_repository_policy.ndr_ecr_repository_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |

## Inputs

| Name                                                                                    | Description         | Type     | Default | Required |
| --------------------------------------------------------------------------------------- | ------------------- | -------- | ------- | :------: |
| <a name="input_app_name"></a> [app_name](#input_app_name)                               | the name of the app | `string` | n/a     |   yes    |
| <a name="input_current_account_id"></a> [current_account_id](#input_current_account_id) | n/a                 | `string` | n/a     |   yes    |
| <a name="input_environment"></a> [environment](#input_environment)                      | n/a                 | `string` | n/a     |   yes    |
| <a name="input_owner"></a> [owner](#input_owner)                                        | n/a                 | `string` | n/a     |   yes    |

## Outputs

| Name                                                                                      | Description |
| ----------------------------------------------------------------------------------------- | ----------- |
| <a name="output_ecr_repository_url"></a> [ecr_repository_url](#output_ecr_repository_url) | n/a         |

<!-- END_TF_DOCS -->
