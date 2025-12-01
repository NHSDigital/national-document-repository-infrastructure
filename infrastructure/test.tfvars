environment                       = "test"
owner                             = "nhse/ndr-team"
domain                            = "access-request-fulfilment.patient-deductions.nhs.uk"
certificate_domain                = "ndr-test.access-request-fulfilment.patient-deductions.nhs.uk"
certificate_subdomain_name_prefix = "api."

standalone_vpc_tag    = "ndr-test"
standalone_vpc_ig_tag = "ndr-test"

cloud_security_email_param_environment = "ndr-test"

apim_environment = "internal-qa."

# SSH Key Management
ssh_key_management_dry_run = "true"  # Enable dry-run for test environment
