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
| [aws_cloudwatch_log_metric_filter.error-filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_metric_alarm.error-alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | n/a | `list(string)` | n/a | yes |
| <a name="input_alarm_name"></a> [alarm\_name](#input\_alarm\_name) | n/a | `string` | n/a | yes |
| <a name="input_error_code"></a> [error\_code](#input\_error\_code) | n/a | `string` | n/a | yes |
| <a name="input_filter_error_code"></a> [filter\_error\_code](#input\_filter\_error\_code) | n/a | `string` | n/a | yes |
| <a name="input_filter_name"></a> [filter\_name](#input\_filter\_name) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
