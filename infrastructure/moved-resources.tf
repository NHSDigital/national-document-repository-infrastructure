#release V1.6.7
moved {
  from = module.update_doc_ref_lambda
  to   = module.update-doc-ref-lambda
}

moved {
  from = module.update_doc_ref_alarm
  to   = module.update-doc-ref-alarm
}

moved {
  from = module.update_doc_ref_alarm_topic
  to   = module.update-doc-ref-alarm-topic
}

moved {
  from = module.document_review_dynamodb_table
  to   = module.document_upload_review_dynamodb_table
}