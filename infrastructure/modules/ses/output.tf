output "report_email_address" {
  value = "ndr-reports@${aws_ses_domain_identity.ndr_ses[0].domain}"
}
