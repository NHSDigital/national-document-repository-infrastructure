moved {
  from = resource.aws_route53_record.validation
  to   = resource.aws_route53_record.mtls_cert_validation
}

moved {
  from = aws_cloudfront_origin_request_policy.viewer
  to   = aws_cloudfront_origin_request_policy.viewer[0]
}

moved {
  from = aws_cloudfront_origin_request_policy.uploader
  to   = aws_cloudfront_origin_request_policy.uploader[0]
}

moved {
  from = aws_cloudfront_cache_policy.nocache
  to   = aws_cloudfront_cache_policy.nocache[0]
}

moved {
  from = aws_iam_role.cognito_unauthenticated[0]
  to   = aws_iam_role.cognito_unauthenticated
}

moved {
  from = aws_iam_policy.cloudwatch_rum_cognito_access[0]
  to   = aws_iam_policy.cloudwatch_rum_cognito_access
}

moved {
  from = aws_iam_role_policy_attachment.cloudwatch_rum_cognito_unauth[0]
  to   = aws_iam_role_policy_attachment.cloudwatch_rum_cognito_unauth
}

moved {
  from = aws_cognito_identity_pool.cloudwatch_rum[0]
  to   = aws_cognito_identity_pool.cloudwatch_rum
}

moved {
  from = aws_cognito_identity_pool_roles_attachment.cloudwatch_rum[0]
  to   = aws_cognito_identity_pool_roles_attachment.cloudwatch_rum
}

moved {
  from = aws_rum_app_monitor.ndr[0]
  to   = aws_rum_app_monitor.ndr
}