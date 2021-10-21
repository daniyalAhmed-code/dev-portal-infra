output "CATALOG_UPDATER_LAMBDA_ARN" {
  value = aws_lambda_function.lambda_catalog_updater_lambda_function.arn
}
output "CATALOG_UPDATER_LAMBDA_NAME" {
  value = aws_lambda_function.lambda_catalog_updater_lambda_function.function_name
}

output "BACKEND_LAMBDA_ARN" {
  value = aws_lambda_function.lambda_backend_lambda_function.arn
}
output "BACKEND_LAMBDA_NAME" {
  value = aws_lambda_function.lambda_backend_lambda_function.function_name
}
output "BACKEND_LAMBDA_INVOKE_ARN" {
  value = aws_lambda_function.lambda_backend_lambda_function.invoke_arn
}

output "COGNITO_PRESIGNUP_TRIGGER_LAMBDA_ARN" {
  value = aws_lambda_function.lambda_cognito_presignup_trigger_function.arn
}
output "COGNITO_PRESIGNUP_TRIGGER_LAMBDA_NAME" {
  value = aws_lambda_function.lambda_cognito_presignup_trigger_function.function_name
}

output "COGNITO_POST_AUTHENTICATION_TRIGGER_LAMBDA_ARN" {
  value = aws_lambda_function.lambda_cognito_post_authentication_trigger_function.arn
}
output "COGNITO_POST_AUTHENTICATION_TRIGGER_LAMBDA_NAME" {
  value = aws_lambda_function.lambda_cognito_post_authentication_trigger_function.function_name
}

output "COGNITO_POST_CONFIRMATION_TRIGGER_LAMBDA_ARN" {
  value = aws_lambda_function.lambda_cognito_post_confirmation_trigger_function.arn
}
output "COGNITO_POST_CONFIRMATION_TRIGGER_LAMBDA_NAME" {
  value = aws_lambda_function.lambda_cognito_post_confirmation_trigger_function.function_name
}

output "CLOUDFRONT_SECURITY_LAMBDA_ARN" {
  value = aws_lambda_function.lambda_cloudfront_security_function.arn
}
output "CLOUDFRONT_SECURITY_LAMBDA_NAME" {
  value = aws_lambda_function.lambda_cloudfront_security_function.function_name
}
output "CLOUDFRONT_SECURITY_LAMBDA_QUALIFIED_ARN" {
  value = aws_lambda_function.lambda_cloudfront_security_function.qualified_arn
}


output "CLOUDFRONT_SECURITY_HEADER_ARN" {
  value = aws_lambda_function.lambda_cloudfront_security_function.arn
}
output "CLOUDFRONT_SECURITY_HEADER_NAME" {
  value = aws_lambda_function.lambda_cloudfront_security_function.function_name
}
output "CLOUDFRONT_SECURITY_HEADER_QUALIFIED_ARN" {
  value = aws_lambda_function.lambda_cloudfront_security_function.qualified_arn
}

output "API_KEY_AUTHORIZATION_LAMBDA_ARN" {
  value = "${aws_lambda_function.lambda_api_key_authoriser_function.arn}"
}
output "API_KEY_AUTHORIZATION_INVOKE_ARN" {
  value = "${aws_lambda_function.lambda_api_key_authoriser_function.invoke_arn}"
}