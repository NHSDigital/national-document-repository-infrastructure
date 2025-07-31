# # import {
# #   to = module.create-token-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_TokenRequestHandler"
# # }
#
# # import {
# #   to = module.get-doc-fhir-lambda[0].aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_GetDocumentReference"
# # }
#
# # import {
# #   to = module.update-upload-state-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_UpdateUploadStateLambda"
# # }
#
# # import {
# #   to = module.logout_lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_LogoutHandler"
# # }
#
# # import {
# #   to = module.lloyd-george-stitch-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_LloydGeorgeStitchLambda"
# # }
#
# # import {
# #   to = module.data-collection-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_DataCollectionLambda"
# # }
#
# # import {
# #   to = module.delete-document-object-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_DeleteDocumentObjectS3"
# # }
#
# # import {
# #   to = module.back_channel_logout_lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_BackChannelLogoutHandler"
# # }
#
# # import {
# #   to = module.get-report-by-ods-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_GetReportByODS"
# # }

import {
  to = module.nhs-oauth-token-generator-lambda.aws_cloudwatch_log_group.lambda_logs[0]
  id = local.is_sandbox ? "/aws/lambda/${terraform.workspace}_NhsOauthTokenGeneratorLambda" : ""
}

# # import {
# #   to = module.login_redirect_lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_LoginRedirectHandler"
# # }
#
# # import {
# #   to = module.send-feedback-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_SendFeedbackLambda"
# # }
#
# # import {
# #   to = module.feature-flags-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_FeatureFlagsLambda"
# # }
#
# # import {
# #   to = module.manage-nrl-pointer-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_ManageNrlPointerLambda"
# # }
#
# # import {
# #   to = module.virus_scan_result_lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_VirusScanResult"
# # }
#
# # import {
# #   to = module.statistical-report-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_StatisticalReportLambda"
# # }
#
# # Required for 
# # ndra
# # Excluded from
# # ndrd
# import {
#   to = module.bulk_upload_metadata_preprocessor_lambda.aws_cloudwatch_log_group.lambda_logs[0]
#   id = "/aws/lambda/ndra_BulkUploadMetadataPreprocessor"
# }
#
# # import {
# #   to = module.bulk-upload-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_BulkUploadLambda"
# # }
#
# # import {
# #   to = module.bulk-upload-metadata-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_BulkUploadMetadataLambda"
# # }
#
# # import {
# #   to = module.pdf-stitching-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_PdfStitchingLambda"
# # }
#
# # import {
# #   to = module.search-patient-details-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_SearchPatientDetailsLambda"
# # }
#
# # Required for 
# # ndra
# # Excluded from
# # ndrd
# import {
#   to = module.search-document-references-fhir-lambda[0].aws_cloudwatch_log_group.lambda_logs[0]
#   id = "/aws/lambda/ndra_SearchDocumentReferencesFHIR"
# }
#
# # import {
# #   to = module.im-alerting-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_IMAlertingLambda"
# # }
#
# # import {
# #   to = module.bulk-upload-report-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_BulkUploadReportLambda"
# # }
#
# # import {
# #   to = module.post-document-references-fhir-lambda[0].aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_PostDocumentReferencesFHIR"
# # }
#
# # import {
# #   to = module.authoriser-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_AuthoriserLambda"
# # }
#
# # Required for 
# # ndra
# # Excluded from
# # ndrd
# import {
#   to = module.access-audit-lambda.aws_cloudwatch_log_group.lambda_logs[0]
#   id = "/aws/lambda/ndra_AccessAuditLambda"
# }
#
# # import {
# #   to = module.mns-notification-lambda[0].aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_MNSNotificationLambda"
# # }
#
# # import {
# #   to = module.search-document-references-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_SearchDocumentReferencesLambda"
# # }
#
# # import {
# #   to = module.generate-lloyd-george-stitch-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_GenerateLloydGeorgeStitch"
# # }
#
# # import {
# #   to = module.create-doc-ref-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_CreateDocRefLambda"
# # }
#
# # import {
# #   to = module.delete-doc-ref-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_DeleteDocRefLambda"
# # }
#
# # import {
# #   to = module.document-manifest-job-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_DocumentManifestJobLambda"
# # }
#
# # import {
# #   to = module.upload_confirm_result_lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_UploadConfirmResultLambda"
# # }
#
# # import {
# #   to = module.generate-document-manifest-lambda.aws_cloudwatch_log_group.lambda_logs[0]
# #   id = "/aws/lambda/ndra_GenerateDocumentManifest"
# # }
