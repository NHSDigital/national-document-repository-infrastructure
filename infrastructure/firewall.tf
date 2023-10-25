module "firewall_waf_v2" {
  source = "./modules/firewall_waf_v2"

  environment = var.environment
  owner       = var.owner
}

resource "aws_wafv2_web_acl_association" "web_acl_association" {
  resource_arn = module.ndr-ecs-fargate.load_balancer_arn
  web_acl_arn  = module.firewall_waf_v2.arn
  depends_on = [
    module.ndr-ecs-fargate,
    module.firewall_waf_v2
  ]
}