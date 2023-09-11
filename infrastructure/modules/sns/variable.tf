variable "topic_name" {
  type = string
}

variable "protocol" {
  type = string
}

variable "delivery_policy" {
  type    = string
  default = <<EOF
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

variable "fifo" {
  type    = bool
  default = false
}

variable "content_based_deduplication" {
  type    = bool
  default = false
}
