#resource "aws_dynamodb_table" "ehr_backup_table" {
#  name = "electronic-health-record-backup"
#}
#
#resource "aws_dynamodb_table" "lg_backup_table" {
#  name = "lloyd_george_backup"
#
#}
#
#resource "aws_dynamodb_table" "bulk_upload_report_backup_table" {
#  name = "bulk_upload_report_backup"
#}
#
#resource "aws_iam_policy" "dynamodb_policy" {
#  name = "dynamo_backup_policy"
#  path = "/"
#
#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        "Effect" : "Allow",
#        "Action" : [
#          "dynamodb:Query",
#          "dynamodb:Scan",
#          "dynamodb:GetItem",
#          "dynamodb:PutItem",
#          "dynamodb:UpdateItem",
#          "dynamodb:DeleteItem",
#        ],
#        "Resource" : [
#          aws_dynamodb_table.ehr_backup_table.arn,
#          aws_dynamodb_table.lg_backup_table.arn,
#          aws_dynamodb_table.bulk_upload_report_backup_table.arn,
#        ]
#      }
#    ]
#  })
#}