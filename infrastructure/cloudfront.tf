locals {
  # required by USA-based CI pipeline runners to run smoke tests
  allow_us_comms = !local.is_production
}

resource "aws_cloudfront_origin_access_control" "s3" {
  name                              = "${terraform.workspace}_cloudfront_s3_oac_policy"
  description                       = "CloudFront S3 OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "never"
  signing_protocol                  = "sigv4"
}

module "cloudfront_firewall_waf_v2" {
  source         = "./modules/firewall_waf_v2"
  cloudfront_acl = true

  environment = var.environment
  owner       = var.owner
  count       = local.is_sandbox ? 0 : 1
  providers   = { aws = aws.us_east_1 }
}

resource "aws_cloudfront_distribution" "s3_presign_mask" {
  price_class = "PriceClass_100"

  origin {
    domain_name              = module.ndr-lloyd-george-store.bucket_regional_domain_name
    origin_id                = module.ndr-lloyd-george-store.bucket_id
    origin_access_control_id = aws_cloudfront_origin_access_control.s3.id
  }
  enabled         = true
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods          = ["HEAD", "GET", "OPTIONS"]
    cached_methods           = ["HEAD", "GET", "OPTIONS"]
    target_origin_id         = module.ndr-lloyd-george-store.bucket_id
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = aws_cloudfront_cache_policy.nocache.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.viewer.id

    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = module.edge-presign-lambda.qualified_arn
    }
  }

  origin {
    domain_name              = module.ndr-document-pending-review-store.bucket_regional_domain_name
    origin_id                = module.ndr-document-pending-review-store.bucket_id
    origin_access_control_id = aws_cloudfront_origin_access_control.s3.id
  }

  ordered_cache_behavior {
    allowed_methods          = ["HEAD", "GET", "OPTIONS"]
    cached_methods           = ["HEAD", "GET", "OPTIONS"]
    path_pattern             = "/review/*"
    target_origin_id         = module.ndr-document-pending-review-store.bucket_id
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = aws_cloudfront_cache_policy.nocache.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.viewer.id

    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = module.edge-presign-lambda.qualified_arn
    }
  }

  origin {
    domain_name              = module.ndr-bulk-staging-store.bucket_regional_domain_name
    origin_id                = module.ndr-bulk-staging-store.bucket_id
    origin_access_control_id = aws_cloudfront_origin_access_control.s3.id
  }

  ordered_cache_behavior {
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods           = ["HEAD", "GET", "OPTIONS"]
    path_pattern             = "/upload/*"
    target_origin_id         = module.ndr-bulk-staging-store.bucket_id
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = aws_cloudfront_cache_policy.nocache.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.viewer.id

    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = module.edge-presign-lambda.qualified_arn
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = local.allow_us_comms ? ["GB", "US"] : ["GB"]
    }
  }

  web_acl_id = try(module.cloudfront_firewall_waf_v2[0].arn, "")
}

resource "aws_cloudfront_origin_request_policy" "viewer" {
  name = "${terraform.workspace}_BlockQueriesAndAllowViewer"

  query_strings_config {
    query_string_behavior = "whitelist"
    query_strings {
      items = [
        "X-Amz-Algorithm",
        "X-Amz-Credential",
        "X-Amz-Date",
        "X-Amz-Expires",
        "X-Amz-SignedHeaders",
        "X-Amz-Signature",
        "X-Amz-Security-Token"
      ]
    }
  }

  headers_config {
    header_behavior = "whitelist"
    headers {
      items = [
        "Host",
        "CloudFront-Viewer-Country",
        "X-Forwarded-For"
      ]
    }
  }

  cookies_config {
    cookie_behavior = "none"
  }
}

resource "aws_cloudfront_cache_policy" "nocache" {
  name        = "${terraform.workspace}_nocache_policy"
  default_ttl = 0
  max_ttl     = 0
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}
# module "cloudfront-distribution-lg" {
#   source                        = "./modules/cloudfront"
#   bucket_domain_name            = module.ndr-lloyd-george-store.bucket_regional_domain_name
#   bucket_id                     = module.ndr-lloyd-george-store.bucket_id
#   qualifed_arn                  = module.edge-presign-lambda.qualified_arn
#   depends_on                    = [module.edge-presign-lambda.qualified_arn, module.ndr-lloyd-george-store.bucket_id, module.ndr-lloyd-george-store.bucket_domain_name, module.ndr-document-pending-review-store.bucket_id, module.ndr-document-pending-review-store.bucket_domain_name]
#   web_acl_id                    = try(module.cloudfront_firewall_waf_v2[0].arn, "")
#   has_secondary_bucket          = local.is_production ? false : true
#   secondary_bucket_domain_name  = module.ndr-document-pending-review-store.bucket_regional_domain_name
#   secondary_bucket_id           = module.ndr-document-pending-review-store.bucket_id
#   secondary_bucket_path_pattern = "review/*"
#   log_bucket_id                 = local.access_logs_bucket_id
# }