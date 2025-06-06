locals {
  pds_tracking_lambdas = [
    "SearchPatientDetailsLambda",
    "BulkUploadLambda",
    "MNSNotificationLambda"
  ]
}

resource "aws_cloudwatch_log_metric_filter" "pds_tracker" {
  for_each = local.is_sandbox ? [] : toset(local.pds_tracking_lambdas)

  name           = "PDSUsageMetricFilter-${each.key}"
  pattern        = "%NDR-TR1%"
  log_group_name = "/aws/lambda/${terraform.workspace}_${each.key}"

  metric_transformation {
    name      = "PDSEventCount"
    namespace = "NDRInsights"
    value     = "1"
  }
}
