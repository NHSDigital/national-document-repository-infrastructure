resource "aws_cloudwatch_metric_alarm" "transfer_kill_switch_stopped_server" {
  count = 1

  alarm_name          = "${terraform.workspace}_transfer_family_kill_switch_stopped"
  namespace           = "Custom/TransferKillSwitch"
  metric_name         = "ServerStopped"
  statistic           = "Sum"
  period              = 600 #check every 10 mins
  evaluation_periods  = 1
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  treat_missing_data  = "notBreaching"

  dimensions = {
    Workspace = terraform.workspace
    # Optionally, also filter to a specific server if you want:
    # ServerId = "s-xxxxxxxxxxxx"
  }

  alarm_description = "Alarm when the Transfer Family kill switch stops a server in workspace ${terraform.workspace}."

  # Reuse the same topic that sends SQS alarms to IMAlertingLambda
  alarm_actions = [module.sqs_alarm_lambda_topic.arn]
  ok_actions    = [module.sqs_alarm_lambda_topic.arn]

  tags = {
    Name         = "${terraform.workspace}_transfer_family_kill_switch_stopped"
    severity     = "high"
    alarm_group  = "transfer_kill_switch"
    alarm_metric = "ServerStopped"
    is_kpi       = "false"
  }
}
