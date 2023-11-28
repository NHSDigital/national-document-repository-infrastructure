resource "aws_backup_vault" "backup_vault" {
  name        = "${terraform.workspace}_backup_vault"
  kms_key_arn = aws_kms_key.encryption_key.arn
}

resource "aws_kms_key" "encryption_key" {
  description             = "KMS key for encrypting backups"
  enable_key_rotation = true
}

resource "aws_kms_alias" "encryption_key_alias" {
  target_key_id = aws_kms_key.encryption_key.id
}