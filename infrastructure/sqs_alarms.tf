locals {
  # monitored_queues = {
  #   # main queues
  #   "nrl_main"       = "${terraform.workspace}-nrl-queue.fifo"
  #   "splunk_main"    = "${terraform.workspace}-splunk-queue"
  #   "stitching_main" = "${terraform.workspace}-stitching-queue"
  #   "lg_bulk_main"   = "${terraform.workspace}-lg-bulk-upload-metadata-queue.fifo"
  #   "lg_inv_main"    = "${terraform.workspace}-lg-bulk-upload-invalid-queue"
  #   "mns_main"       = "${terraform.workspace}-mns-notification-queue"
  #
  #   # dead-letter queues
  #   "nrl_dlq"       = "${terraform.workspace}-deadletter-nrl-queue.fifo"
  #   "stitching_dlq" = "${terraform.workspace}-deadletter-stitching-queue"
  #   "mns_dlq"       = "${terraform.workspace}-deadletter-mns-notification-queue"
  # }


  monitored_queues = {
    # main queues
    "nrl_main"       = module.sqs-nrl-queue.queue_name
    "splunk_main"    = length(module.sqs-splunk-queue) > 0 ? module.sqs-splunk-queue[0].queue_name : ""
    "stitching_main" = module.sqs-stitching-queue.queue_name
    "lg_bulk_main"   = module.sqs-lg-bulk-upload-metadata-queue.queue_name
    "lg_inv_main"    = module.sqs-lg-bulk-upload-invalid-queue.queue_name
    "mns_main"       = module.sqs-mns-notification-queue[0].queue_name
    # dead-letter queues
    "nrl_dlq"       = module.sqs-nrl-queue.dlq_name
    "stitching_dlq" = module.sqs-stitching-queue.dlq_name
    "mns_dlq"       = module.sqs-mns-notification-queue[0].dlq_name
  }


  days_until_alarm = [
    [6, "medium"],
    [10, "high"]
  ]

  flat_list = flatten([
    for queue_key in keys(local.monitored_queues) : [
      for day in local.days_until_alarm : [
        queue_key,
        local.monitored_queues[queue_key],
        day[0], #day
        day[1]  #severity
      ]
    ]
  ])

  monitored_queue_day_list = [
    for i in range(0, length(local.flat_list), 4) : [
      local.flat_list[i],     # key
      local.flat_list[i + 1], # queue name
      local.flat_list[i + 2], # day
      local.flat_list[i + 3], # severity
    ]
  ]
}

locals {
  is_test_sandbox = contains([], terraform.workspace) # empty list disables sandbox detection, for testing only
}
# TODO: Delete is_test_sandbox, and change all call of is_test_sandbox to is_sandbox

module "global_sqs_age_alarm_topic" {
  count                 = local.is_test_sandbox ? 0 : 1 # TODO:change is_test_sandbox to is_sandbox
  source                = "./modules/sns"
  sns_encryption_key_id = module.sns_encryption_key.id
  topic_name             = "global-sqs-age-alarm-topic"
  topic_protocol         = "email"
  is_topic_endpoint_list = true
  topic_endpoint_list    = nonsensitive(split(",", data.aws_ssm_parameter.cloud_security_notification_email_list.value))

  delivery_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudwatch.amazonaws.com"
        },
        "Action" : "SNS:Publish",
        "Condition" : {
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:cloudwatch:eu-west-2:${data.aws_caller_identity.current.account_id}:alarm:*"
          }
        },
        "Resource" : "*"
      }
    ]
  })
}


resource "aws_cloudwatch_metric_alarm" "sqs_oldest_message" {
  count = local.is_test_sandbox ? 0 : length(local.monitored_queue_day_list)  # TODO:change is_test_sandbox to is_sandbox

  alarm_name          = "${terraform.workspace}_${local.monitored_queue_day_list[count.index][0]}_oldest_message_alarm_${local.monitored_queue_day_list[count.index][2]}d"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60 # TODO: change to 86400 (24h))
  statistic           = "Maximum"
  threshold           = local.monitored_queue_day_list[count.index][2] # TODO: change to local.monitored_queue_day_list[count.index][2]*24*60*60
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = local.monitored_queue_day_list[count.index][1]
  }

  alarm_description = "Alarm when a message in queue '${local.monitored_queue_day_list[count.index][1]}' is older than '${local.monitored_queue_day_list[count.index][2]}' days."

  alarm_actions = [module.sqs_alarm_lambda_topic.arn]
  ok_actions    = [module.sqs_alarm_lambda_topic.arn]

  tags = {
    Name         = "${terraform.workspace}_${local.monitored_queue_day_list[count.index][0]}_oldest_message_alarm_${local.monitored_queue_day_list[count.index][2]}d"
    severity     = local.monitored_queue_day_list[count.index][3]
    alarm_group  = local.monitored_queue_day_list[count.index][1]
    alarm_metric = "ApproximateAgeOfOldestMessage"
    is_kpi       = "true"
  }
}

module "sqs_alarm_lambda_topic" {
  source                = "./modules/sns"
  sns_encryption_key_id = module.sns_encryption_key.id
  topic_name     = "sqs-alarms-to-lambda-topic"
  topic_protocol = "lambda"
  topic_endpoint = module.im-alerting-lambda.lambda_arn

  delivery_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudwatch.amazonaws.com"
        },
        "Action" : ["SNS:Publish"],
        "Condition" : {
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:cloudwatch:eu-west-2:${data.aws_caller_identity.current.account_id}:alarm:*"
          }
        },
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_lambda_permission" "sqs_im_alerting" {
  statement_id  = "AllowExecutionFromSQSAlarmSNS"
  action        = "lambda:InvokeFunction"
  function_name = module.im-alerting-lambda.lambda_arn
  principal     = "sns.amazonaws.com"
  source_arn    = module.sqs_alarm_lambda_topic.arn
}