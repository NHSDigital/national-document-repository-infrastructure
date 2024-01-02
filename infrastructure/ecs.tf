module "ndr-ecs-fargate" {
  source                   = "./modules/ecs"
  ecs_cluster_name         = "app-cluster"
  vpc_id                   = module.ndr-vpc-ui.vpc_id
  public_subnets           = module.ndr-vpc-ui.public_subnets
  private_subnets          = module.ndr-vpc-ui.private_subnets
  sg_name                  = "${terraform.workspace}-fargate-sg"
  ecs_launch_type          = "FARGATE"
  ecs_cluster_service_name = "${terraform.workspace}-ecs-cluster-service"
  ecr_repository_url       = module.ndr-docker-ecr-ui.ecr_repository_url
  environment              = var.environment
  owner                    = var.owner
  domain                   = var.domain
  certificate_domain       = var.certificate_domain
  container_port           = 80
  alarm_actions_arn_list   = local.is_sandbox ? [] : [aws_sns_topic.alarm_notifications_topic[0].arn]
  logs_bucket              = aws_s3_bucket.logs_bucket.bucket
}


module "ndr-ecs-container-port-ssm-parameter" {
  source              = "./modules/ssm_parameter"
  name                = "container_port"
  description         = "Docker container port number for ${var.environment}"
  resource_depends_on = module.ndr-ecs-fargate
  value               = module.ndr-ecs-fargate.container_port
  type                = "SecureString"
  owner               = var.owner
  environment         = var.environment
}