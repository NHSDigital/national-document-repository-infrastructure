output "gateway_resource_id" {
  value = aws_api_gateway_resource.gateway_resource.id
}

output "gateway_preflight_method" {
  value = aws_api_gateway_method.proxy_method.id
}

output "gateway_proxy_method" {
  value = aws_api_gateway_resource.gateway_resource.id
}