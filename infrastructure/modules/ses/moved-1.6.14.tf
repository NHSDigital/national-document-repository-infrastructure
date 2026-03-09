moved {
  from = aws_ses_domain_identity.ndr_ses[0]
  to   = aws_ses_domain_identity.ndr_ses
}

moved {
  from = aws_ses_domain_dkim.ndr_dkim[0]
  to   = aws_ses_domain_dkim.ndr_dkim
}

moved {
  from = aws_ses_domain_identity_verification.ndr_ses_domain_verification[0]
  to   = aws_ses_domain_identity_verification.ndr_ses_domain_verification
}
