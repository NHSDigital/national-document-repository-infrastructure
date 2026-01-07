resource "aws_ssm_parameter" "reporting_ses_from_address" {
  name  = "/prs/${var.environment}/user-input/reporting-ses-from-address"
  type  = "String"
  value = "ndr-reports@${var.domain}"

  tags = {
    Name = "${terraform.workspace}-ssm"
  }
}
