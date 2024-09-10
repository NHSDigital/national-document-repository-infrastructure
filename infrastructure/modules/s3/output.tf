output "s3_object_access_policy" {
  value = aws_iam_policy.s3_document_data_policy.arn
}

output "s3_list_object_policy" {
  value = aws_iam_policy.s3_list_object_policy.arn
}

output "bucket_id" {
  value = aws_s3_bucket.bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.bucket.bucket_domain_name
}