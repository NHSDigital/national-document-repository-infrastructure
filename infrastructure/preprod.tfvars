environment                       = "pre-prod"
shared_infra_workspace            = "pre-prod"
owner                             = "nhse/ndr-team"
domain                            = "national-document-repository.nhs.uk"
certificate_domain                = "pre-prod.national-document-repository.nhs.uk"
certificate_subdomain_name_prefix = "api."
cloudfront_subdomain_name_prefix  = "files"

standalone_vpc_tag    = "ndr-pre-prod"
standalone_vpc_ig_tag = "ndr-pre-prod"

cloud_security_email_param_environment = "pre-prod"

apim_environment = "int."

ssh_key_management_dry_run = true

deletion_protection_enabled = true
