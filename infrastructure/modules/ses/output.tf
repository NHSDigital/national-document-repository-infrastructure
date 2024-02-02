output "mail_from_domain_name" {
  value = try(aws_ses_domain_mail_from.ndr_mail_from[0].mail_from_domain, "")
}

output "ses_domain_identity_arn" {
  value = try(aws_ses_domain_identity.ndr_ses[0].arn, "")
}

output "is_enable" {
  value = var.enable
}