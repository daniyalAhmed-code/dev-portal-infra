output "outputs" {
  value = module.cognito.COGNITO_USERPOOL_DOMAIN
}
output "domain_output" {
  value = module.cloudfront.CLOUDFRONT_DOMAIN
}