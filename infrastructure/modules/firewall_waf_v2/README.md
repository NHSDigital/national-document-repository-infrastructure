# WAFv2 Web ACL Module

## Features

- WAFv2 Web ACL provisioning
- Regex pattern sets for:
  - XSS in body
  - Large request bodies
  - CMS-related URIs
- CloudFront-compatible WAF scope toggle
- BotControl disabled when used for API
- Named and tagged by environment and owner

---

## Usage

```hcl
module "waf_acl" {
  source = "./modules/waf-acl"

  # Required: true if the ACL is being used for CloudFront (sets scope to CLOUDFRONT)
  cloudfront_acl = true

  # Required: used to tag and namespace the ACL and regex pattern sets
  environment = "prod"

  # Required: resource owner for tagging
  owner = "security-team"

  # True if using the firewall for an api - removes AWSBotControl and SizeRestrictions_BODY
  api = true
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
| [aws_cloudwatch_log_group.waf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.waf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_wafv2_regex_pattern_set.exclude_cms_uri](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_regex_pattern_set) | resource |
| [aws_wafv2_regex_pattern_set.large_body_uri](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_regex_pattern_set) | resource |
| [aws_wafv2_regex_pattern_set.xss_body_uri](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_regex_pattern_set) | resource |
| [aws_wafv2_web_acl.waf_v2_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_logging_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.waf_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api"></a> [api](#input\_api) | True if using the firewall for an api - removes AWSBotControl and SizeRestrictions\_BODY | `bool` | `false` | no |
| <a name="input_cloudfront_acl"></a> [cloudfront\_acl](#input\_cloudfront\_acl) | Set to true if this WAF ACL is for a CloudFront distribution. | `bool` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name used for tagging and resource naming. | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Name of the owner used for tagging. | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The arn of the web acl. |
<!-- END_TF_DOCS -->
