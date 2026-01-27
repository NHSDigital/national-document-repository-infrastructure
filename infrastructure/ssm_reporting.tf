resource "aws_ssm_parameter" "reporting_ses_from_address" {
  count = local.is_shared_workspace ? 1 : 0
  name  = "/prs/${var.environment}/user-input/reporting-ses-from-address"
  type  = "String"
  value = "ndr-reports@${var.domain}"

  tags = {
    Name = "/prs/${var.environment}/user-input/reporting-ses-from-address"
  }
}

data "aws_ssm_parameters_by_path" "reporting_user_input" {
  count           = local.is_shared_workspace ? 0 : 1
  path            = "/prs/${var.environment}/user-input"
  recursive       = false
  with_decryption = true
}

locals {
  reporting_ses_from_address_name = "/prs/${var.environment}/user-input/reporting-ses-from-address"
  reporting_user_input_params = local.is_shared_workspace ? {} : zipmap(
    data.aws_ssm_parameters_by_path.reporting_user_input[0].names,
    data.aws_ssm_parameters_by_path.reporting_user_input[0].values
  )
  reporting_ses_from_address_value = (
    local.is_shared_workspace
    ? aws_ssm_parameter.reporting_ses_from_address[0].value
    : lookup(local.reporting_user_input_params, local.reporting_ses_from_address_name, "ndr-reports@${var.domain}")
  )
}
