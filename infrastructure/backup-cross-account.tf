resource "aws_backup_plan" "cross_account_backup_schedule" {
  name = "${terraform.workspace}-cross-account-backup-plan"

  rule {
    rule_name         = "CrossAccount6pmBackup"
    target_vault_name = "${terraform.workspace}_backup_vault"
    #    schedule          = "cron(0 18 * * *)"
    schedule = "cron(20 15 * * *)"

    lifecycle {
      delete_after       = 35
      cold_storage_after = 0
    }
  }
}

data "aws_ssm_parameter" "target_backup_vault_arn" {
  name = "backup-target-vault-arn"
}

data "aws_ssm_parameter" "backup_target_account" {
  name = "backup-target-account"
}

data "aws_iam_policy_document" "cross_account_backup_assume_role" {
  statement = [
    {
      effect = "Allow"

      principals = {
        type        = "Service"
        identifiers = ["backup.amazonaws.com"]
      }

      actions = ["sts:AssumeRole"]
    },
    {
      sid : "Allow 694282683086 to copy into pre-prod_s3_backup_vault",
      effect : "Allow",
      action : "backup:CopyIntoBackupVault",
      resource : data.aws_ssm_parameter.target_backup_vault_arn.value,
      principal : {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_ssm_parameter.backup_target_account.value}:root"]
      }
    }
  ]
}

resource "aws_iam_policy" "copy_policy" {
  name        = "${terraform.workspace}_cross_account_copy_policy"
  description = "Permissions required to copy to another accounts backup vault"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : {
      "Sid" : "Allow user to copy into backup account",
      "Effect" : "Allow",
      "Action" : "backup:CopyIntoBackupVault",
      "Resource" : data.aws_ssm_parameter.target_backup_vault_arn.value
    }
  })
}
resource "aws_iam_role_policy_attachment" "s3_cross_account_copy_policy" {
  role       = aws_iam_role.s3_cross_account_backup_iam_role.name
  policy_arn = aws_iam_policy.copy_policy.arn
}

resource "aws_backup_selection" "s3_cross_account_backup_selection" {
  iam_role_arn = aws_iam_role.s3_cross_account_backup_iam_role.arn
  name         = "${terraform.workspace}_s3_cross_account_backup_selection"
  plan_id      = aws_backup_plan.cross_account_backup_schedule.id

  resources = [
    module.ndr-document-store.bucket_arn,
    module.ndr-lloyd-george-store.bucket_arn
  ]
}

resource "aws_iam_role" "s3_cross_account_backup_iam_role" {
  name               = "${terraform.workspace}_s3_cross_account_backup_iam_role"
  assume_role_policy = data.aws_iam_policy_document.backup_assume_role.json
}

resource "aws_iam_role_policy_attachment" "cross_account_backup_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.s3_cross_account_backup_iam_role.name
  depends_on = [aws_iam_role.s3_cross_account_backup_iam_role]
}

resource "aws_iam_role_policy_attachment" "cross_account_restore_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  role       = aws_iam_role.s3_cross_account_backup_iam_role.name
  depends_on = [aws_iam_role.s3_cross_account_backup_iam_role]
}

resource "aws_iam_role_policy_attachment" "cross_account_s3_backup_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AWSBackupServiceRolePolicyForS3Backup"
  role       = aws_iam_role.s3_cross_account_backup_iam_role.name
  depends_on = [aws_iam_role.s3_cross_account_backup_iam_role]
}

resource "aws_iam_role_policy_attachment" "s3_cross_account_restore_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AWSBackupServiceRolePolicyForS3Restore"
  role       = aws_iam_role.s3_cross_account_backup_iam_role.name
  depends_on = [aws_iam_role.s3_cross_account_backup_iam_role]
}

