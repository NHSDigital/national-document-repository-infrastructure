# Route53 DNS Records Module

## Features

- Create or look up a Route53 hosted zone
- DNS record for custom domain API Gateway mapping
- Creates workspace-based CNAME for a configurable DNS name
- Allows lookup of a certificate domain for external DNS records.
- Configurable ownership and environment tagging

---

## Usage

```hcl
module "dns" {
  source = "./modules/route53"

  # Required: Full domain name of the custom API Gateway domain (e.g. "api-dev.example.com")
  api_gateway_full_domain_name = "api-dev.myapp.example.com"

  # Required: Subdomain for the API Gateway (e.g. "api-dev")
  api_gateway_subdomain_name = "api-dev"

  # Required: Zone ID used by the API Gateway’s custom domain (for record attachment)
  api_gateway_zone_id = "Z123456789ABCDEF"

  # Required: Domain name for the Route53 hosted zone (e.g. "example.com")
  domain = "example.com"

  # Required: Target DNS name for the Fargate or load-balanced endpoint
  dns_name = "fargate-lb-123456.eu-west-2.elb.amazonaws.com"

  # Required: Tagging context
  environment = "prod"
  owner       = "platform"

  # Optional: Use a shared hosted zone (e.g. for multi-module ARF usage)
  using_arf_hosted_zone = true
}


```

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                   | Version |
| ------------------------------------------------------ | ------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | ~> 5.0  |

## Resources

| Name                                                                                                                                    | Type        |
| --------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_route53_record.ndr_fargate_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)     | resource    |
| [aws_route53_record.ndr_gateway_api_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource    |
| [aws_route53_zone.ndr_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone)                   | resource    |
| [aws_route53_zone.ndr_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone)                | data source |

## Inputs

| Name                                                                                                                  | Description                                                                                                          | Type     | Default | Required |
| --------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | -------- | ------- | :------: |
| <a name="input_api_gateway_full_domain_name"></a> [api_gateway_full_domain_name](#input_api_gateway_full_domain_name) | Full domain name for api gateway custom domain. Example: api-dev.access-request-fulfilment.patient-deductions.nhs.uk | `string` | n/a     |   yes    |
| <a name="input_api_gateway_subdomain_name"></a> [api_gateway_subdomain_name](#input_api_gateway_subdomain_name)       | Subdomain name for api gateway custom domain. Example: api-dev                                                       | `string` | n/a     |   yes    |
| <a name="input_api_gateway_zone_id"></a> [api_gateway_zone_id](#input_api_gateway_zone_id)                            | Zone Id for api gateway custom domain                                                                                | `string` | n/a     |   yes    |
| <a name="input_dns_name"></a> [dns_name](#input_dns_name)                                                             | n/a                                                                                                                  | `string` | n/a     |   yes    |
| <a name="input_domain"></a> [domain](#input_domain)                                                                   | n/a                                                                                                                  | `string` | n/a     |   yes    |
| <a name="input_environment"></a> [environment](#input_environment)                                                    | n/a                                                                                                                  | `string` | n/a     |   yes    |
| <a name="input_owner"></a> [owner](#input_owner)                                                                      | n/a                                                                                                                  | `string` | n/a     |   yes    |
| <a name="input_using_arf_hosted_zone"></a> [using_arf_hosted_zone](#input_using_arf_hosted_zone)                      | n/a                                                                                                                  | `bool`   | `true`  |    no    |

## Outputs

| Name                                                     | Description |
| -------------------------------------------------------- | ----------- |
| <a name="output_zone_id"></a> [zone_id](#output_zone_id) | n/a         |

<!-- END_TF_DOCS -->
