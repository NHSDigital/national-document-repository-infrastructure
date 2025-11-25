resource "aws_iam_policy" "s3_document_data_policy" {
  name = "${terraform.workspace}_${var.bucket_name}_get_document_data_policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucketMultipartUploads",
          "s3:ListBucketVersions",
          "s3:ListBucket",
          "s3:DeleteObjectTagging",
          "s3:GetObjectRetention",
          "s3:DeleteObjectVersion",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectAttributes",
          "s3:RestoreObject",
          "s3:PutObjectVersionTagging",
          "s3:DeleteObjectVersionTagging",
          "s3:GetObjectVersionAttributes",
          "s3:GetObjectAcl",
          "s3:AbortMultipartUpload",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectTagging",
          "s3:PutObjectTagging",
          "s3:GetObjectVersion",
        ],
        "Resource" : ["${aws_s3_bucket.bucket.arn}/*"]
      }
    ]
  })
}

resource "aws_iam_policy" "s3_list_object_policy" {
  name = "${terraform.workspace}_${var.bucket_name}_list_object_policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
        ],
        "Resource" : ["${aws_s3_bucket.bucket.arn}"]
      }
    ]
  })
}

resource "aws_iam_policy" "s3_backup_policy" {
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "S3BucketBackupPermissions",
          "Action" : [
            "s3:GetInventoryConfiguration",
            "s3:PutInventoryConfiguration",
            "s3:ListBucketVersions",
            "s3:ListBucket",
            "s3:GetBucketVersioning",
            "s3:GetBucketNotification",
            "s3:PutBucketNotification",
            "s3:GetBucketLocation",
            "s3:GetBucketTagging",
            "s3:GetBucketAcl"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:s3:::*"
          ]
        },
        {
          "Sid" : "S3ObjectBackupPermissions",
          "Action" : [
            "s3:GetObjectAcl",
            "s3:GetObject",
            "s3:GetObjectVersionTagging",
            "s3:GetObjectVersionAcl",
            "s3:GetObjectTagging",
            "s3:GetObjectVersion"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:s3:::*/*"
          ]
        },
        {
          "Sid" : "S3GlobalPermissions",
          "Action" : [
            "s3:ListAllMyBuckets"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "*"
          ]
        },
        {
          "Sid" : "KMSBackupPermissions",
          "Action" : [
            "kms:Decrypt",
            "kms:DescribeKey"
          ],
          "Effect" : "Allow",
          "Resource" : "*",
          "Condition" : {
            "StringLike" : {
              "kms:ViaService" : "s3.*.amazonaws.com"
            }
          }
        },
        {
          "Sid" : "EventsPermissions",
          "Action" : [
            "events:DescribeRule",
            "events:EnableRule",
            "events:PutRule",
            "events:DeleteRule",
            "events:PutTargets",
            "events:RemoveTargets",
            "events:ListTargetsByRule",
            "events:DisableRule"
          ],
          "Effect" : "Allow",
          "Resource" : "arn:aws:events:*:*:rule/AwsBackupManagedRule*"
        },
        {
          "Sid" : "EventsMetricsGlobalPermissions",
          "Action" : [
            "cloudwatch:GetMetricData",
            "events:ListRules"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ]
    }
  )
}