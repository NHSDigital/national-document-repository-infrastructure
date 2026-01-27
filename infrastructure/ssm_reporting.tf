resource "aws_ssm_parameter" "reporting_ses_from_address" {
  count = local.is_shared_workspace ? 1 : 0
  name  = "/prs/${var.environment}/user-input/reporting-ses-from-address"
  type  = "String"
  value = "ndr-reports@${var.domain}"

  tags = {
    Name = "/prs/${var.environment}/user-input/reporting-ses-from-address"
  }
}
data "aws_ssm_parameter" "reporting_ses_from_address" {
  name = "/prs/${var.environment}/user-input/reporting-ses-from-address"
}