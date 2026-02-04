resource "aws_ses_configuration_set" "reporting" {
  count = local.is_shared_workspace ? 1 : 0
  name  = "${terraform.workspace}-reporting"
}

resource "aws_ses_event_destination" "reporting_to_sns" {
  name                   = "sns-feedback"
  configuration_set_name = aws_ses_configuration_set.reporting.name
  enabled                = true

  matching_types = [
    "bounce",
    "reject"
  ]

  sns_destination {
    topic_arn = module.ses_feedback_topic.arn
  }

  depends_on = [
    module.ses_feedback_topic,
    aws_lambda_permission.allow_sns_invoke_ses_feedback_monitor
  ]
}
