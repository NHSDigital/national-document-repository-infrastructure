# SES Domain Identity & DKIM Module

## Features

- SES domain identity registration
- SES domain verification trigger
- DKIM setup for secure email validation
- Route53 DNS records for DKIM CNAMEs
- Toggle-based resource creation

---

## Usage

```hcl
module "ses_identity" {
  source = "./modules/ses"

  # Required: Root domain (e.g. example.com)
  domain = "example.com"

  # Required: Subdomain or prefix used to create identity.
  domain_prefix = "email"

  # Required: ID of the hosted zone where DNS records will be created
  zone_id = "Z0123456789ABCDEFG"

  # Required: Whether to enable creation of SES identity
  enable = true
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.dmarc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.ndr_ses_dkim_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.ses_mail_from_mx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.ses_mail_from_spf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_ses_domain_dkim.ndr_dkim](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_dkim) | resource |
| [aws_ses_domain_identity.ndr_ses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity) | resource |
| [aws_ses_domain_identity_verification.ndr_ses_domain_verification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity_verification) | resource |
| [aws_ses_domain_mail_from.reporting](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_mail_from) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain"></a> [domain](#input\_domain) | The root domain name to be registered with SES and used for verification. | `string` | n/a | yes |
| <a name="input_is_sandbox"></a> [is\_sandbox](#input\_is\_sandbox) | Whether the workspace being created is a sandbox. | `bool` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | The Route53 hosted zone ID where DNS verification records will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_report_email_address"></a> [report\_email\_address](#output\_report\_email\_address) | n/a |
<!-- END_TF_DOCS -->
