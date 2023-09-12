resource "aws_cloudwatch_metric_alarm" "repo_alarm" {
  alarm_name        = "${terraform.workspace}_repo_${var.alarm_name}"   
  alarm_description = var.alarm_description
  namespace         = "AWS/ApiGateway"
  dimensions = {
    ApiName = var.api_name
  }
  metric_name         = var.metric_name
  comparison_operator = "GreaterThanThreshold"
  threshold           = "0"
  period              = "300"
  evaluation_periods  = "1"
  statistic           = "Sum"
  actions_enabled     = "true"
  alarm_actions       = var.alarm_actions
  ok_actions          = var.ok_actions
}
