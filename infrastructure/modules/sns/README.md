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
| [aws_sns_topic.sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.sns_invocation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | n/a | `bool` | `false` | no |
| <a name="input_delivery_policy"></a> [delivery\_policy](#input\_delivery\_policy) | n/a | `string` | `"{\n  \"http\": {\n    \"defaultHealthyRetryPolicy\": {\n      \"minDelayTarget\": 20,\n      \"maxDelayTarget\": 20,\n      \"numRetries\": 3,\n      \"numMaxDelayRetries\": 0,\n      \"numNoDelayRetries\": 0,\n      \"numMinDelayRetries\": 0,\n      \"backoffFunction\": \"linear\"\n    },\n    \"disableSubscriptionOverrides\": false,\n    \"defaultThrottlePolicy\": {\n      \"maxReceivesPerSecond\": 1\n    }\n  }\n}\n"` | no |
| <a name="input_fifo"></a> [fifo](#input\_fifo) | n/a | `bool` | `false` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | n/a | `string` | n/a | yes |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
