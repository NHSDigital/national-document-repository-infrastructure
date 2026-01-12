resource "aws_ses_configuration_set" "reporting" {
  name = "${terraform.workspace}-reporting"
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
}
