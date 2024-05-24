resource "aws_iam_policy" "lambda_layer_policy" {
  name = "${terraform.workspace}_${var.layer_name}_lambda_layer_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:GetLayerVersion",
          "lambda:ListLayerVersions",
          "lambda:ListLayers"
        ],
        Resource = [
          "arn:aws:lambda:eu-west-2:${var.account_id}:layer:${terraform.workspace}_${var.layer_name}_lambda_layer:*"
        ]
      }
    ]
  })
}