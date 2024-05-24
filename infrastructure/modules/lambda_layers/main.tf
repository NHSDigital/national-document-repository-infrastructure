data "archive_file" "lambda_layer_placeholder" {
  type        = "zip"
  source_file = "placeholder_lambda.py"
  output_path = "placeholder_lambda_payload.zip"
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename         = data.archive_file.lambda_layer_placeholder.output_path
  layer_name       = "${terraform.workspace}_${var.layer_name}_lambda_layer"
  compatible_runtimes = ["python3.11"]
  compatible_architectures = ["x86_64"]
}