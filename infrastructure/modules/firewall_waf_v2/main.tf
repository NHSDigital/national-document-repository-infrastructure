resource "aws_wafv2_web_acl" "waf_v2_acl" {
  name        = "${terraform.workspace}${var.api ? "-api" : var.cloudfront_acl ? "-cloudfront" : ""}-fw-waf-v2"
  description = "A WAF to secure the Repo application."
  scope       = var.cloudfront_acl ? "CLOUDFRONT" : "REGIONAL"

  default_action {
    allow {}
  }

  # Block an IP if it has attempted to access more than 1000 within 5 minutes
  rule {
    name     = "RateLimit"
    priority = 0

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 1000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${terraform.workspace}-waf-v2--RateLimit"
      sampled_requests_enabled   = true
    }
  }

  dynamic "rule" {
    for_each = local.waf_rules_map
    content {
      name     = rule.value["name"]
      priority = rule.key + 1

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value["managed_rule_name"]
          vendor_name = "AWS"


          dynamic "rule_action_override" {
            for_each = rule.value.excluded_rules
            content {
              name = rule_action_override.value
              action_to_use {
                allow {}
              }
            }
          }

          dynamic "scope_down_statement" {
            for_each = rule.value["bypass"]
            content {
              not_statement {
                statement {
                  regex_pattern_set_reference_statement {
                    arn = aws_wafv2_regex_pattern_set.exclude_cms_uri.arn

                    field_to_match {
                      uri_path {}
                    }

                    text_transformation {
                      priority = 0
                      type     = "NONE"
                    }
                  }
                }
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value["cloudwatch_metrics_name"]
        sampled_requests_enabled   = true
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${terraform.workspace}-fw-waf_v2"
    sampled_requests_enabled   = true
  }

  tags = {
    Name        = "${terraform.workspace}-firewall_waf_v2"
    Owner       = var.owner
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

resource "aws_cloudwatch_log_group" "waf" {
  name = "aws-waf-logs-${aws_wafv2_web_acl.waf_v2_acl.name}"

  retention_in_days = 0
}

resource "aws_wafv2_web_acl_logging_configuration" "this" {
  log_destination_configs = [aws_cloudwatch_log_group.waf.arn]
  resource_arn            = aws_wafv2_web_acl.waf_v2_acl.arn
}

resource "aws_cloudwatch_log_resource_policy" "waf" {
  policy_document = data.aws_iam_policy_document.waf_logging.json
  policy_name     = "${aws_cloudwatch_log_group.waf.name}-resource-policy"
}

data "aws_iam_policy_document" "waf_logging" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.waf.arn}:*"]
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
      variable = "aws:SourceArn"
    }
    condition {
      test     = "StringEquals"
      values   = [tostring(data.aws_caller_identity.current.account_id)]
      variable = "aws:SourceAccount"
    }
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}