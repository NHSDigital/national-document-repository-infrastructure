resource "aws_cloudwatch_metric_alarm" "alb_alarm_4XX" {
  alarm_name          = "4XX-status-${aws_lb.ecs_lb.name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_ELB_4XX_Count"
  period              = 60
  statistic           = "Sum"
  threshold           = 20
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = aws_lb.ecs_lb.arn_suffix
  }

  alarm_description = "This alarm indicates that at least 20 4XX statuses have occurred on ${aws_lb.ecs_lb.name} in a minute."
  actions_enabled   = "true"
  alarm_actions     = var.alarm_actions_arn_list
}

resource "aws_cloudwatch_metric_alarm" "alb_alarm_5XX" {
  alarm_name          = "5XX-status-${aws_lb.ecs_lb.name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_ELB_4XX_Count"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = aws_lb.ecs_lb.arn_suffix
  }

  alarm_description = "This alarm indicates that at least 5 5XX statuses have occurred on ${aws_lb.ecs_lb.name} within 5 minutes."
  actions_enabled   = "true"
  alarm_actions     = var.alarm_actions_arn_list
}