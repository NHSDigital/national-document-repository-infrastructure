output "ses_domain_identity_arn" {
  value = try(aws_ses_domain_identity.ndr_ses[0].arn, "")
}

output "is_enable" {
  value = var.enable
}