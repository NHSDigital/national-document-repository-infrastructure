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

resource "aws_cloudwatch_log_metric_filter" "bulk_upload_metadata_processor_expedite_validation_failed" {
  count = local.is_sandbox ? 0 : 1
  name           = "${terraform.workspace}-bulk-upload-metadata-processor-expedite-validation-failed"
  log_group_name = "/aws/lambda/${module.bulk-upload-metadata-processor-lambda.function_name}"
  pattern        = "\"EXPEDITE_UPLOAD_VALIDATION_FAILED\""

  metric_transformation {
    name      = "ExpediteUploadValidationFailed"
    namespace = "NDRInsights"
    value     = "1"
  }
}
