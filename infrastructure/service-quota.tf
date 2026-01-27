# https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_iam-quotas.html#reference_iam-quotas-entities
resource "aws_servicequotas_service_quota" "customer_managed_policies_per_account" {
  count = local.is_sandbox || local.is_production ? 0 : 1

  service_code = "iam"
  quota_code   = "L-E95E4862"
  value        = 5000

  provider = aws.us_east_1
}

resource "aws_servicequotas_service_quota" "customer_managed_roles_per_account" {
  count = local.is_sandbox || local.is_production ? 0 : 1

  service_code = "iam"
  quota_code   = "L-FE177D64"
  value        = 5000

  provider = aws.us_east_1
}

# https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html#compute-and-storage
resource "aws_servicequotas_service_quota" "lambda_concurrent_executions_increase" {
  count = local.is_sandbox || local.is_production ? 0 : 1 # The service code for AWS Lambda

  service_code = "lambda"
  quota_code   = "L-B99A9384"
  value        = 10000

  provider = aws.us_east_1
}

resource "aws_servicequotas_service_quota" "customer_managed_origin_request_policies_per_account" {
  count = local.is_sandbox || local.is_production ? 0 : 1

  service_code = "cloudfront"
  quota_code   = "L-C3659C43"
  value        = 40

  provider = aws.us_east_1
}