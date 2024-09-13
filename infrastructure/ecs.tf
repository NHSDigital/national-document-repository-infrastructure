module "ndr-ecs-fargate-app" {
  source                   = "./modules/ecs"
  ecs_cluster_name         = "app-cluster"
  is_lb_needed             = true
  is_autoscaling_needed    = true
  is_service_needed        = true
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
  resource_depends_on = module.ndr-ecs-fargate-app
  value               = module.ndr-ecs-fargate-app.container_port
  type                = "SecureString"
  owner               = var.owner
  environment         = var.environment
}

module "ndr-ods-update-fargate" {
  count                    = local.is_sandbox ? 0 : 1
  source                   = "./modules/ecs"
  ecs_cluster_name         = "ods-weekly-update"
  vpc_id                   = module.ndr-vpc-ui.vpc_id
  public_subnets           = module.ndr-vpc-ui.public_subnets
  private_subnets          = module.ndr-vpc-ui.private_subnets
  sg_name                  = "${terraform.workspace}-ods-weekly-update-sg"
  ecs_launch_type          = "FARGATE"
  ecs_cluster_service_name = "${terraform.workspace}-ods-weekly-update"
  ecr_repository_url       = module.ndr-docker-ecr-weekly-ods-update[0].ecr_repository_url
  environment              = var.environment
  owner                    = var.owner
  container_port           = 80
  desired_count            = 0
  is_autoscaling_needed    = false
  is_lb_needed             = false
  is_service_needed        = false
  alarm_actions_arn_list   = []
  logs_bucket              = aws_s3_bucket.logs_bucket.bucket
  task_role                = aws_iam_role.ods_weekly_update_task_role[0].arn
  environment_vars = [
    {
      "name" : "table_name",
      "value" : module.lloyd_george_reference_dynamodb_table.table_name
    },
    {
      "name" : "PDS_FHIR_IS_STUBBED",
      "value" : tostring(local.is_sandbox)
    }
  ]
  ecs_container_definition_memory = 512
  ecs_container_definition_cpu    = 256
  ecs_task_definition_memory      = 512
  ecs_task_definition_cpu         = 256
}

resource "aws_iam_role" "ods_weekly_update_task_role" {
  count = local.is_sandbox ? 0 : 1
  name  = "${terraform.workspace}_ods_weekly_update_task_role"
  managed_policy_arns = [
    module.lloyd_george_reference_dynamodb_table.dynamodb_policy,
    aws_iam_policy.ssm_access_policy.arn,
  ]
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : [
              "ecs-tasks.amazonaws.com"
            ]
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}