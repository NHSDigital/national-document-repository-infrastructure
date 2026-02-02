locals {
  reporting_from_domain = (local.is_production
    ? var.domain
    : "${var.shared_infra_workspace}.${var.domain}"
  )

  reporting_ses_from_address_value = "ndr-reports@${local.reporting_from_domain}"
}
