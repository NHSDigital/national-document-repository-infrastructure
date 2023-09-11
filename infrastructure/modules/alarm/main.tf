resource "aws_cloudwatch_log_metric_filter" "error-filter" {
  name           = var.filter_name //BadRequestFilter
  log_group_name = aws_cloudwatch_log_group.job-runner-cloudwatch-log-group.name
  pattern        = var.error_code //"BAD_REQUEST"
  metric_transformation {
    name      = "${var.error_code}-Metric"
    namespace = "${terraform.workspace}-RepoMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "error-alarm" {
  alarm_name          = var.alarm_name //bad-request
  alarm_description = "Triggers when a 5xx status code has been returned by the DocStoreAPI."
  metric_name         = aws_cloudwatch_log_metric_filter.error-we-care-about-metric-filter.name
  threshold           = "0"
  statistic           = "Sum"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = "1"
  evaluation_periods  = "1"
  period              = "60"
  namespace           = "${terraform.workspace}-RepoMetrics"
  alarm_actions       = var.alarm_actions
}