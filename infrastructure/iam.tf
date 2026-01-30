data "aws_iam_policy_document" "reporting_ses" {
  statement {
    sid    = "SESAccess"
    effect = "Allow"

    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]

    resources = [
      "arn:aws:ses:${var.region}:${data.aws_caller_identity.current.account_id}:identity/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "ses:FromAddress"
      values   = [local.reporting_ses_from_address_value]
    }
  }
}
