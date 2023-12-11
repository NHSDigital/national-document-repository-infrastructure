module "nems_sns_sns_queue" {
  source = "./modules/sns"
  current_account_id = data.aws_caller_identity.current.account_id
  delivery_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudwatch.amazonaws.com"
        },
        "Action" : [
          "SNS:Publish",
        ],
        "Condition" : {
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:cloudwatch:eu-west-2:${data.aws_caller_identity.current.account_id}:alarm:*"
          }
        }
        "Resource" : "*"
      }
    ]
  })
  sns_encryption_key_id = module.sns_encryption_key.id
  topic_endpoint = module.sqs-nems-queue[0].endpoint
  topic_name = "sns_nems_queue"
  topic_protocol = "sqs"
}