resource "aws_backup_vault" "backup_vault" {
  name        = "${terraform.workspace}_backup_vault"
  kms_key_arn = aws_kms_key.encryption_key.arn
}

resource "aws_kms_key" "encryption_key" {
  description         = "KMS key for encrypting backups"
  enable_key_rotation = true
}

resource "aws_kms_alias" "encryption_key_alias" {
  target_key_id = aws_kms_key.encryption_key.id
}

resource "aws_backup_plan" "backup_schedule" {
  name = "tf_example_backup_plan"

  rule {
    rule_name         = "6pm backup"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = "cron(0 18 * * *)"

    lifecycle {
      delete_after = 35
    }
  }
}

resource "aws_backup_vault_policy" "backup_policy" {
  backup_vault_name = aws_backup_vault.backup_vault.name
  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Id": "default",
      "Statement": [
        {
          "Sid": "Allow production environments ",
          "Effect": "Allow",
          "Action": "backup:CopyIntoBackupVault",
          "Resource": "*",
          "Principal": {
            "AWS": "arn:aws:iam::${data.aws_ssm_parameter.backup-source-account}:root"
          }
        }
      ]
    }
  )
}

data "aws_ssm_parameter" "backup-source-account" {
  name = "backup-target-account"
}

