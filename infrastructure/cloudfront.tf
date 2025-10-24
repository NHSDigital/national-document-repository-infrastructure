module "cloudfront_firewall_waf_v2" {
  source         = "./modules/firewall_waf_v2"
  cloudfront_acl = true

  environment = var.environment
  owner       = var.owner
  count       = local.is_sandbox ? 0 : 1
  providers   = { aws = aws.us_east_1 }
}

module "cloudfront-distribution-lg" {
  has_secondary_bucket          = true
  secondary_bucket_domain_name  = module.ndr-document-pending-review-store.bucket_domain_name
  secondary_bucket_id           = module.ndr-document-pending-review-store.bucket_id
  secondary_bucket_path_pattern = "/test/*"
  source                        = "./modules/cloudfront"
  bucket_domain_name            = "${terraform.workspace}-${var.lloyd_george_bucket_name}.s3.eu-west-2.amazonaws.com"
  bucket_id                     = module.ndr-lloyd-george-store.bucket_id
  qualifed_arn                  = module.edge-presign-lambda.qualified_arn
  depends_on                    = [module.edge-presign-lambda.qualified_arn, module.ndr-lloyd-george-store.bucket_id, module.ndr-lloyd-george-store.bucket_domain_name, module.ndr-document-pending-review-store.bucket_id, module.ndr-document-pending-review-store.bucket_domain_name]
  web_acl_id                    = try(module.cloudfront_firewall_waf_v2[0].arn, "")
  access_log_bucket             = local.is_production ? "${aws_s3_bucket.access_logs[0].bucket}.s3.eu-west-2.amazonaws.com" : null
  log_prefix                    = "cloudfront/"
}