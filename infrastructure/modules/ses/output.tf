output "mail_from_domain_name" {
  value = try(aws_ses_domain_mail_from.ndr_mail_from[0].mail_from_domain, "")
}
