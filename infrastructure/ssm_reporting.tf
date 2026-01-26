resource "aws_ssm_parameter" "reporting_ses_from_address" {
  count = local.is_shared_infra_workspace ? 1 : 0

  name  = local.reporting_ses_from_address_parameter_name
  type  = "String"
  value = "ndr-reports@${var.domain}"

  tags = {
    Name = local.reporting_ses_from_address_parameter_name
  }
}

locals {
  reporting_ses_from_address_value = (
    local.is_shared_infra_workspace
    ? aws_ssm_parameter.reporting_ses_from_address[0].value
    : data.terraform_remote_state.shared.outputs.reporting_ses_from_address_value
  )
}

output "reporting_ses_from_address_value" {
  description = "SES From address used by reporting (shared output consumed by other workspaces)."
  value       = local.reporting_ses_from_address_value
}
