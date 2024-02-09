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
| [aws_appconfig_application.ndr-app-config-application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_application) | resource |
| [aws_appconfig_configuration_profile.ndr-app-config-profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_configuration_profile) | resource |
| [aws_appconfig_deployment.ndr-app-config-deployment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_deployment) | resource |
| [aws_appconfig_deployment_strategy.ndr-app-config-deployment-strategy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_deployment_strategy) | resource |
| [aws_appconfig_environment.ndr-app-config-environment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_environment) | resource |
| [aws_appconfig_hosted_configuration_version.ndr-app-config-profile-version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_hosted_configuration_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_environment_name"></a> [config\_environment\_name](#input\_config\_environment\_name) | n/a | `string` | n/a | yes |
| <a name="input_config_profile_name"></a> [config\_profile\_name](#input\_config\_profile\_name) | n/a | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_config_application_arn"></a> [app\_config\_application\_arn](#output\_app\_config\_application\_arn) | n/a |
| <a name="output_app_config_application_id"></a> [app\_config\_application\_id](#output\_app\_config\_application\_id) | n/a |
| <a name="output_app_config_configuration_profile_id"></a> [app\_config\_configuration\_profile\_id](#output\_app\_config\_configuration\_profile\_id) | n/a |
| <a name="output_app_config_environment_id"></a> [app\_config\_environment\_id](#output\_app\_config\_environment\_id) | n/a |
