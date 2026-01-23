locals {
  is_shared_infra_workspace                 = terraform.workspace == var.shared_infra_workspace
  reporting_ses_from_address_parameter_name = "/prs/${var.environment}/user-input/reporting-ses-from-address"
}

resource "aws_ssm_parameter" "reporting_ses_from_address" {
  count = local.is_shared_infra_workspace ? 1 : 0

  name  = local.reporting_ses_from_address_parameter_name
  type  = "String"
  value = "ndr-reports@${var.domain}"

  tags = {
    Name = local.reporting_ses_from_address_parameter_name
  }
}

data "aws_ssm_parameter" "reporting_ses_from_address" {
  count = local.is_shared_infra_workspace ? 0 : 1
  name  = local.reporting_ses_from_address_parameter_name
}

locals {
  reporting_ses_from_address_value = local.is_shared_infra_workspace ? aws_ssm_parameter.reporting_ses_from_address[0].value : data.aws_ssm_parameter.reporting_ses_from_address[0].value
}
