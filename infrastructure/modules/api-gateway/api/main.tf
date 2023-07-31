resource "aws_api_gateway_rest_api" "ndr_api" {
  name        = var.gateway_name
  description = var.gateway_desc
}

output "ndr_api_id" {
  value = aws_api_gateway_rest_api.ndr_api.id
}