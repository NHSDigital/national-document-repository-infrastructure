variable "topic_name" {
  type        = string
  description = "Name of the SNS topic"
}

variable "protocol" {
  type        = string
  description = "SNS protocol type, most commonly https or lambda"
}

variable "delivery_policy" {
  type        = string
  description = "Attach delivery or IAM policy"
  default     = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}

variable "enable_fifo" {
  type        = bool
  default     = false
  description = "Attach first in first out policy to notification queue"
}

variable "enable_deduplication" {
  type        = bool
  default     = false
  description = "Prevent content based duplication in notification queue"

}

variable "function_arn" {
  type        = string
  description = "Provide the AWS ARN to link the SNS module to the path of the Lambda / Service"
}