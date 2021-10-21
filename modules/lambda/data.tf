data "archive_file" "lambda_catalog_updater_lambda_function" {
  type        = "zip"
  source_dir  = "${path.module}/code/catalog-updater"
  output_path = "${path.module}/zip/catalog-updater.zip"
}
data "archive_file" "lambda_backend_lambda_function" {
  type        = "zip"
  source_dir  = "${path.module}/code/backend"
  output_path = "${path.module}/zip/backend.zip"
}

data "archive_file" "lambda_cognito_pre_signup_trigger_function" {
  type        = "zip"
  source_dir  = "${path.module}/code/cognito-pre-signup-trigger"
  output_path = "${path.module}/zip/cognito-pre-signup-trigger.zip"
}
data "archive_file" "lambda_cognito_post_confirmation_trigger_function" {
  type        = "zip"
  source_dir  = "${path.module}/code/cognito-post-confirmation-trigger"
  output_path = "${path.module}/zip/cognito-post-confirmation-trigger.zip"
}
data "archive_file" "lambda_cognito_post_authentication_trigger_function" {
  type        = "zip"
  source_dir  = "${path.module}/code/cognito-post-authentication-trigger"
  output_path = "${path.module}/zip/cognito-post-authentication-trigger.zip"
}
data "archive_file" "lambda_cognito_userpool_client_settings_function" {
  type        = "zip"
  source_dir  = "${path.module}/code/cfn-cognito-user-pools-client-settings"
  output_path = "${path.module}/zip/cfn-cognito-user-pools-client-settings.zip"
}
data "archive_file" "lambda_cognito_userpool_domain_function" {
  type        = "zip"
  source_dir  = "${path.module}/code/cfn-cognito-user-pools-domain"
  output_path = "${path.module}/zip/cfn-cognito-user-pools-domain.zip"
}
data "archive_file" "lambda_dump_v3_account_data_function" {
  type        = "zip"
  source_dir  = "${path.module}/code/dump-v3-account-data"
  output_path = "${path.module}/zip/dump-v3-account-data.zip"
}
data "archive_file" "lambda_user_group_importer_function" {
  type        = "zip"
  source_dir  = "${path.module}/code/user-group-importer"
  output_path = "${path.module}/zip/user-group-importer.zip"
}
data "archive_file" "lambda_cloudfront_security_function" {
  type        = "zip"
  source_dir  = "${path.module}/code/cloudfront-security"
  output_path = "${path.module}/zip/cloudfront-security.zip"
}
data "archive_file" "lambda_security_header_function" {
  type        = "zip"
  source_dir  = "${path.module}/code/security-header"
  output_path = "${path.module}/zip/security-header.zip"
}
data "archive_file" "lambda_api_key_authoriser_function" {
  type        = "zip"
  source_dir  = "${path.module}/code/authoriser"
  output_path = "${path.module}/zip/authoriser.zip"
}