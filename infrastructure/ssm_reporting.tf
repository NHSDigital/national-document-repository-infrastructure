resource "aws_ssm_parameter" "reporting_ses_from_address" {
  count = local.is_shared_infra_workspace ? 1 : 0

  name  = "/prs/${var.environment}/user-input/reporting-ses-from-address"
  type  = "String"
  value = local.reporting_ses_from_address_value

  tags = {
    Name = "/prs/${var.environment}/user-input/reporting-ses-from-address"
  }
}
