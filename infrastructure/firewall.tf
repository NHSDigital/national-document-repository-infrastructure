module "firewall_waf_v2" {
  source = "./modules/firewall_waf_v2"

  environment = var.environment
  owner       = var.owner
  count = (terraform.workspace == "ndra" ||
    terraform.workspace == "ndrb" ||
    terraform.workspace == "ndrc" ||
  terraform.workspace == "ndrd") ? 0 : 1
}

resource "aws_wafv2_web_acl_association" "web_acl_association" {
  resource_arn = module.ndr-ecs-fargate-app.load_balancer_arn
  web_acl_arn  = module.firewall_waf_v2[0].arn

  count = (terraform.workspace == "ndra" ||
    terraform.workspace == "ndrb" ||
    terraform.workspace == "ndrc" ||
  terraform.workspace == "ndrd") ? 0 : 1
  depends_on = [
    module.ndr-ecs-fargate-app,
    module.firewall_waf_v2[0]
  ]
}