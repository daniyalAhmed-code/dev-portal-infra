output "COGNITO_USER_POOL" {
  value = aws_cognito_user_pool.cognito_user_pool.id
}
output "COGNITO_IDENTITY_POOL" {
  value = aws_cognito_identity_pool.cognito_identity_pool.id
}
output "COGNITO_USERPOOL_ARN" {
  value = aws_cognito_user_pool.cognito_user_pool.arn
}
output "COGNITO_USERPOOL_CLIENT" {
  value = aws_cognito_user_pool_client.cognito_user_pool_client.id
}
output "COGNITO_USERPOOL_DOMAIN" {
  value = aws_cognito_user_pool_domain.main.id
}
