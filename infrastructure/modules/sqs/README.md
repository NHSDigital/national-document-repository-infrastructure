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
| [aws_iam_policy.sqs_queue_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_sqs_queue.queue_deadletter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.sqs_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_redrive_allow_policy.terraform_queue_redrive_allow_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_redrive_allow_policy) | resource |
| [aws_sqs_queue_redrive_policy.dlq_redrive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_redrive_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_delay"></a> [delay](#input\_delay) | The time in seconds that the delivery of all messages in the queue will be delayed | `number` | `0` | no |
| <a name="input_enable_deduplication"></a> [enable\_deduplication](#input\_enable\_deduplication) | Prevent content based duplication in queue | `bool` | `false` | no |
| <a name="input_enable_dlq"></a> [enable\_dlq](#input\_enable\_dlq) | n/a | `bool` | `false` | no |
| <a name="input_enable_fifo"></a> [enable\_fifo](#input\_enable\_fifo) | Attach first in first out policy to sqs | `bool` | `false` | no |
| <a name="input_enable_sse"></a> [enable\_sse](#input\_enable\_sse) | Enable server-side encryption (SSE) of message content with SQS-owned encryption keys, requires kms resource for queue | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Tags | `string` | n/a | yes |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK | `string` | `null` | no |
| <a name="input_max_receive_count"></a> [max\_receive\_count](#input\_max\_receive\_count) | n/a | `number` | `1` | no |
| <a name="input_max_size_message"></a> [max\_size\_message](#input\_max\_size\_message) | Max message size in bytes before sqs rejects the message | `number` | `2048` | no |
| <a name="input_max_visibility"></a> [max\_visibility](#input\_max\_visibility) | Time in seconds during which Amazon SQS prevents all consumers from receiving and processing the message | `number` | `30` | no |
| <a name="input_message_retention"></a> [message\_retention](#input\_message\_retention) | Number of seconds sqs keeps a message | `number` | `86400` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | n/a | `string` | n/a | yes |
| <a name="input_receive_wait"></a> [receive\_wait](#input\_receive\_wait) | Number of seconds sqs will wait for a message when ReceiveMessage is received | `number` | `2` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Same as sqs queue arn. For use when setting the queue as endpoint of sns topic |
| <a name="output_sqs_arn"></a> [sqs\_arn](#output\_sqs\_arn) | n/a |
| <a name="output_sqs_id"></a> [sqs\_id](#output\_sqs\_id) | n/a |
| <a name="output_sqs_policy"></a> [sqs\_policy](#output\_sqs\_policy) | Arn for the iam policy for accessing this queue |
| <a name="output_sqs_url"></a> [sqs\_url](#output\_sqs\_url) | n/a |
