resource "aws_cloudwatch_metric_alarm" "alb_alarm_4XX" {
  alarm_name          = "4XX-status-${aws_lb.ecs_lb.name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "API_Gateway_4XX_Error"
  period              = "60"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    AutoScalingGroupName = aws_lb.ecs_lb.arn_suffix
  }

  alarm_description = "This alarm indicates that at least 20 4XX statuses have occurred on ${aws_lb.ecs_lb.name} in a minute."
  alarm_actions     = var.alarm_actions_arn_list
}

resource "aws_cloudwatch_metric_alarm" "alb_alarm_5XX" {
  alarm_name          = "5XX-status-${aws_lb.ecs_lb.name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_Target_5XX_Count"
  period              = "600"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    AutoScalingGroupName = aws_lb.ecs_lb.arn_suffix
  }

  alarm_description = "This alarm indicates that at least 5 5XX statuses have occurred on ${aws_lb.ecs_lb.name} in 5 minutes."
  alarm_actions     = var.alarm_actions_arn_list
}