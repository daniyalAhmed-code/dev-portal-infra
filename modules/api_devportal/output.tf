output "API_GATEWAY_API" {
  value = aws_api_gateway_rest_api.api-gateway.execution_arn
}
output "API_GATEWAY_ID" {
  value = aws_api_gateway_rest_api.api-gateway.id
}
