resource "aws_cloudwatch_log_metric_filter" "pds_tracker_search_patient_details_lambda" {
  name           = "PDSUsageMetricFilter"
  pattern        = "%NDR-TR1%"
  log_group_name = "/aws/lambda/${terraform.workspace}_SearchPatientDetailsLambda"

  metric_transformation {
    name      = "PDSEventCount"
    namespace = "NDRInsights"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "pds_tracker_bulk_upload_lambda" {
  name           = "PDSUsageMetricFilter"
  pattern        = "%NDR-TR1%"
  log_group_name = "/aws/lambda/${terraform.workspace}_BulkUploadLambda"

  metric_transformation {
    name      = "PDSEventCount"
    namespace = "NDRInsights"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "pds_tracker_MNS_notification_lambda" {
  name           = "PDSUsageMetricFilter"
  pattern        = "%NDR-TR1%"
  log_group_name = "/aws/lambda/${terraform.workspace}_MNSNotificationLambda"

  metric_transformation {
    name      = "PDSEventCount"
    namespace = "NDRInsights"
    value     = "1"
  }
}

