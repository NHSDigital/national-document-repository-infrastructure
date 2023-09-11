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
| [aws_sqs_queue.sh_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_delay"></a> [delay](#input\_delay) | n/a | `number` | `0` | no |
| <a name="input_enable_sse"></a> [enable\_sse](#input\_enable\_sse) | n/a | `bool` | `true` | no |
| <a name="input_max_message"></a> [max\_message](#input\_max\_message) | n/a | `number` | `2048` | no |
| <a name="input_max_visibility"></a> [max\_visibility](#input\_max\_visibility) | n/a | `number` | `30` | no |
| <a name="input_message_retention"></a> [message\_retention](#input\_message\_retention) | n/a | `number` | `86400` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_receive_wait"></a> [receive\_wait](#input\_receive\_wait) | n/a | `number` | `2` | no |

## Outputs

No outputs.
