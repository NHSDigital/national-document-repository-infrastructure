data "aws_ssm_parameter" "splunk_trusted_principal" {
  name  = "/prs/user-input/external/splunk-trusted-principal"
  count = var.cloud_only_service_instances
}

data "aws_iam_policy_document" "splunk_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = var.cloud_only_service_instances > 0 ? split(",", data.aws_ssm_parameter.splunk_trusted_principal[0].value) : []
    }
  }
}

resource "aws_iam_role" "splunk_sqs_forwarder" {
  count              = local.is_sandbox ? 0 : 1
  name               = "${var.environment}_splunk_sqs_forwarder_role"
  description        = "Role to allow Repo to integrate with Splunk"
  assume_role_policy = data.aws_iam_policy_document.splunk_trust_policy.json
}

resource "aws_iam_role_policy" "test_policy" {
  name = "${var.environment}_splunk_access_policy"
  role = aws_iam_role.splunk_sqs_forwarder.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:GetQueueAttributes",
          "sqs:ListQueues",
          "sqs:ReceiveMessage",
          "sqs:GetQueueUrl",
          "sqs:SendMessage",
          "sqs:DeleteMessage"
        ]
        Resource = [
          module.sqs-splunk-queue[0].sqs_arn,
        ]
      },
    ]
  })
}

resource "aws_iam_policy" "lambda_audit_splunk_sqs_queue_send_policy" {
  count = local.is_sandbox ? 0 : 1
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      "Sid"    = "shsqsstatement",
      "Effect" = "Allow",
      "Action" = [
        "sqs:SendMessage",
      ],
      "Resource" = [
        module.sqs-splunk-queue[0].sqs_arn
      ]
  }] })
}