resource "aws_ssm_parameter" "reporting_ses_from_address" {
  count = local.is_shared_workspace ? 1 : 0
  name  = "/prs/${var.environment}/user-input/reporting-ses-from-address"
  type  = "String"
  value = local.reporting_ses_from_address_default

  tags = {
    Name = "/prs/${var.environment}/user-input/reporting-ses-from-address"
  }
}

data "aws_ssm_parameters_by_path" "reporting_user_input" {
  count           = local.is_shared_workspace ? 0 : 1
  path            = "/prs/${var.environment}/reporting/config"
  recursive       = false
  with_decryption = true
}

locals {
  reporting_from_domain = (local.is_production
    ? var.domain
    : "${var.shared_infra_workspace}.${var.domain}"
  )

  reporting_ses_from_address_name    = "/prs/${var.environment}/user-input/reporting-ses-from-address"
  reporting_ses_from_address_default = "ndr-reports@${local.reporting_from_domain}"

  reporting_user_input_params = local.is_shared_workspace ? {} : zipmap(
    data.aws_ssm_parameters_by_path.reporting_user_input[0].names,
    data.aws_ssm_parameters_by_path.reporting_user_input[0].values
  )

  reporting_ses_from_address_value = (local.is_shared_workspace
    ? aws_ssm_parameter.reporting_ses_from_address[0].value
    : lookup(
      local.reporting_user_input_params,
      local.reporting_ses_from_address_name,
      local.reporting_ses_from_address_default
    )
  )
}
