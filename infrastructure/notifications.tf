module "sns-nems-topic" {
  source     = "./modules/sns"
  topic_name = "${terraform.workspace}-sns-nems-topic"
  protocol   = "https"
}