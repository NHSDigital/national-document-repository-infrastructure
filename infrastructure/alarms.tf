module "badrequest-alarm" {
  source        = "./modules/alarm"
  filter_name   = "BadRequestFilter"
  alarm_name    = "bad-request"
  error_code    = "BAD_REQUEST"
  # alarm_actions       = [var.sns_topic_arn]

}