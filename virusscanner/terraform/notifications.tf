data "aws_cloudformation_export" "proactive_notifications_sns_topic" {
  name = "${aws_cloudformation_stack.s3_virus_scanning_stack.name}-proactive-notifications-sns-topic"
  tags = {
    Name = "Virus Scanner SNS Topic"
    Environment = var.environment
    Owner = var.owner
  }
}

resource "aws_ssm_parameter" "virus_scan_notifications_sns_topic_arn" {
  name  = "/prs/${var.environment}/virus-scan-notifications-sns-topic-arn"
  type  = "String"
  value = data.aws_cloudformation_export.proactive_notifications_sns_topic.value
  tags = {
    Name = "Virus Scanner SNS ARN"
    Environment = var.environment
    Owner = var.owner
  }
}

resource "aws_sns_topic_subscription" "proactive_notifications_sns_topic_subscription" {
  for_each  = toset(nonsensitive(split(",", data.aws_ssm_parameter.cloud_security_notification_email_list.value)))
  endpoint  = each.value
  protocol  = "email"
  topic_arn = data.aws_cloudformation_export.proactive_notifications_sns_topic.value
  filter_policy = jsonencode({
    "notificationType" : ["scanResult"],
    "scanResult" : ["Infected", "Error", "Unscannable", "Suspicious"]
  })
  tags = {
    Name = "Virus Scanner SNS subscription"
    Environment = var.environment
    Owner = var.owner
  }
}

data "aws_ssm_parameter" "cloud_security_notification_email_list" {
  name = "/prs/${var.environment}/user-input/cloud-security-notification-email-list"
  tags = {
    Name = "Virus scanner notification email list"
    Description = "This list of emails will be notified when an infected file is quarantined"
    Environment = var.environment
    Owner = var.owner
  }
}
