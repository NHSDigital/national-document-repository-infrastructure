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


resource "aws_backup_vault_policy" "backup_policy" {
  backup_vault_name = aws_backup_vault.backup_vault.name

  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "Allow ${data.aws_ssm_parameter.backup-source-account} to copy into pre-prod_s3_backup_vault",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::${data.aws_ssm_parameter.backup-source-account}:root"
                },
                "Action": "backup:CopyIntoBackupVault",
                "Resource": "*"
            }
        ]
    }
  )
}

data "aws_ssm_parameter" "backup-source-account" {
  name = "backup-source-account"
}

