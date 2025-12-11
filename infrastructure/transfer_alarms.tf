resource "aws_cloudwatch_metric_alarm" "transfer_family_kill_switch_stopped_server" {
  alarm_name          = "${terraform.workspace}_transfer_family_kill_switch_stopped"
  namespace           = "Custom/TransferFamilyKillSwitch"
  metric_name         = "ServerStopped"
  statistic           = "Sum"
  period              = 60 #check every 10 mins
  evaluation_periods  = 1
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  treat_missing_data  = "notBreaching"

  dimensions = {
    Workspace = terraform.workspace
  }

  alarm_description = "Alarm when the Transfer Family kill switch stops a server in workspace ${terraform.workspace}."

  alarm_actions = [module.sqs_alarm_lambda_topic.arn]
  ok_actions    = [module.sqs_alarm_lambda_topic.arn]

  tags = {
    Name         = "${terraform.workspace}_transfer_family_kill_switch_stopped"
    severity     = "high"
    alarm_group  = "${terraform.workspace}-transfer-family-kill-switch"
    alarm_metric = "ServerStopped"
    is_kpi       = "false"
  }
}
