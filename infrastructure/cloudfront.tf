module "cloudfront_firewall_waf_v2" {
  source         = "./modules/firewall_waf_v2"
  cloudfront_acl = true

  environment = var.environment
  owner       = var.owner
  count       = local.is_sandbox ? 0 : 1
  providers   = { aws = aws.us_east_1 }
}

module "cloudfront-distribution-lg" {
  source             = "./modules/cloudfront"
  bucket_domain_name = "${terraform.workspace}-${var.lloyd_george_bucket_name}.s3.eu-west-2.amazonaws.com"
  bucket_id          = module.ndr-lloyd-george-store.bucket_id
  qualifed_arn       = module.edge-presign-lambda.qualified_arn
  depends_on         = [module.edge-presign-lambda.qualified_arn, module.ndr-lloyd-george-store.bucket_id, module.ndr-lloyd-george-store.bucket_domain_name]
  web_acl_id         = try(module.cloudfront_firewall_waf_v2[0].arn, "")
}
