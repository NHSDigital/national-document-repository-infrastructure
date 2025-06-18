locals {
  lambda_layers = concat(
    [
      "arn:aws:lambda:eu-west-2:580247275435:layer:LambdaInsightsExtension:53",
      "arn:aws:lambda:eu-west-2:282860088358:layer:AWS-AppConfig-Extension:120"
    ], 
    var.extra_layers
  )
}
