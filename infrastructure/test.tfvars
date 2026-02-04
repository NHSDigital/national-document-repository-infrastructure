environment                       = "test"
shared_infra_workspace            = "ndr-test"
owner                             = "nhse/ndr-team"
domain                            = "access-request-fulfilment.patient-deductions.nhs.uk"
certificate_domain                = "ndr-test.access-request-fulfilment.patient-deductions.nhs.uk"
certificate_subdomain_name_prefix = "api."
cloudfront_subdomain              = "file."

standalone_vpc_tag    = "ndr-test"
standalone_vpc_ig_tag = "ndr-test"

cloud_security_email_param_environment = "ndr-test"

apim_environment = "internal-qa."

ssh_key_management_dry_run = true
