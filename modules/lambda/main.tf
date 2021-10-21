locals {
  FEEDBACK_TABLE_NAME = var.IS_ADMIN ? var.FEEDBACK_TABLE_NAME : null
}

resource "aws_lambda_layer_version" "lambda-common-layer" {
  provider            = aws.src
  filename            = "${path.module}/layers/nodejs.zip"
  layer_name          = "dev-portal-common"
  compatible_runtimes = ["nodejs12.x"]
  source_code_hash    = "${filebase64sha256("${path.module}/layers/nodejs.zip")}"
}


resource "aws_lambda_function" "lambda_catalog_updater_lambda_function" {
  provider            = aws.src
  filename         = "${path.module}/zip/catalog-updater.zip"
  function_name    = "${var.RESOURCE_PREFIX}-catalog-updater"
  role             = "${var.LAMBDA_CATALOG_UPDATER_ROLE_ARN}"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambda_catalog_updater_lambda_function.output_base64sha256}"
  runtime          = "nodejs12.x"
  timeout          = "20"
  layers           = ["${aws_lambda_layer_version.lambda-common-layer.arn}"]

  environment {
    variables = {
      "BucketName" = "${var.ARTIFACTS_S3_BUCKET_NAME}"
    }
  }
}

resource "aws_lambda_function" "lambda_backend_lambda_function" {
  provider            = aws.src
  filename         = "${path.module}/zip/backend.zip"
  function_name    = "${var.RESOURCE_PREFIX}-backend"
  role             = "${var.LAMBDA_BACKEND_ROLE_ARN}"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambda_backend_lambda_function.output_base64sha256}"
  runtime          = "nodejs12.x"
  timeout          = "20"
  layers           = ["${aws_lambda_layer_version.lambda-common-layer.arn}"]
  environment {
    variables = {
      "NODE_ENV"                  = "${var.NODE_ENV}"
      "WEBSITE_BUCKET_NAME"       = "${var.WEBSITE_BUCKET_NAME}"
      "StaticBucketName"          = "${var.ARTIFACTS_S3_BUCKET_NAME}"
      "CustomersTableName"        = "${var.CUSTOMER_TABLE_NAME}"
      "PreLoginAccountsTableName" = "${var.PRE_LOGIN_ACCOUNT_TABLE_NAME}"
      "FeedbackTableName"         = "${var.FEEDBACK_TABLE_NAME}"
      "FeedbackSnsTopicArn"       = "${var.FEEDBACK_SNS_TOPIC_ARN}"
      "UserPoolId"                = "${var.USERPOOL_ID}"
      "AdminsGroupName"           = "${var.ADMIN_GROUP_NAME}"
      "RegisteredGroupName"       = "${var.REGISTERED_GROUP_NAME}"
      "DevelopmentMode"           = "${var.DEVELOPMENT_MODE}"
      "CatalogUpdaterFunctionArn" = aws_lambda_function.lambda_catalog_updater_lambda_function.arn
    }
  }
}



resource "aws_lambda_function" "lambda_cognito_presignup_trigger_function" {
  provider            = aws.src
  filename         = "${path.module}/zip/cognito-pre-signup-trigger.zip"
  function_name    = "${var.RESOURCE_PREFIX}-CognitoPreSignupTriggerFn"
  role             = "${var.LAMBDA_COGNITO_PRESIGNUP_TRIGGER_ROLE_ARN}"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambda_cognito_pre_signup_trigger_function.output_base64sha256}"
  runtime          = "nodejs12.x"
  timeout          = "3"
  layers           = ["${aws_lambda_layer_version.lambda-common-layer.arn}"]
  environment {
    variables = {
      "AccountRegistrationMode" = "${var.ACCOUNT_REGISTRATION_MODE}"
    }
  }
}

resource "aws_lambda_function" "lambda_cognito_post_confirmation_trigger_function" {
  provider            = aws.src
  filename         = "${path.module}/zip/cognito-post-confirmation-trigger.zip"
  function_name    = "${var.RESOURCE_PREFIX}-CognitoPostConfirmationTriggerFn"
  role             = "${var.LAMBDA_COGNITO_POST_CONFIRMATION_TRIGGER_ROLE_ARN}"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambda_cognito_post_confirmation_trigger_function.output_base64sha256}"
  runtime          = "nodejs12.x"
  timeout          = "3"
  layers           = ["${aws_lambda_layer_version.lambda-common-layer.arn}"]
  environment {
    variables = {
      "AccountRegistrationMode"   = "${var.ACCOUNT_REGISTRATION_MODE}"
      "PreLoginAccountsTableName" = "${var.PRE_LOGIN_ACCOUNT_TABLE_NAME}"
      "RegisteredGroupName"       = "${var.REGISTERED_GROUP_NAME}"
    }
  }
}
resource "aws_lambda_function" "lambda_cognito_post_authentication_trigger_function" {
  provider            = aws.src
  filename         = "${path.module}/zip/cognito-post-authentication-trigger.zip"
  function_name    = "${var.RESOURCE_PREFIX}-CognitoPostAuthenticationTriggerFn"
  role             = "${var.LAMBDA_COGNITO_POST_AUTHENTICATION_TRIGGER_ROLE_ARN}"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambda_cognito_post_authentication_trigger_function.output_base64sha256}"
  runtime          = "nodejs12.x"
  timeout          = "3"
  layers           = ["${aws_lambda_layer_version.lambda-common-layer.arn}"]
  environment {
    variables = {
      "AccountRegistrationMode"   = "${var.ACCOUNT_REGISTRATION_MODE}"
      "PreLoginAccountsTableName" = "${var.PRE_LOGIN_ACCOUNT_TABLE_NAME}"
      "CustomersTableName"        = "${var.CUSTOMER_TABLE_NAME}"
      "RegisteredGroupName"       = "${var.REGISTERED_GROUP_NAME}"
    }
  }
}

resource "aws_lambda_function" "lambda_cognito_userpool_client_settings_function" {
  provider            = aws.src
  filename         = "${path.module}/zip/cfn-cognito-user-pools-client-settings.zip"
  function_name    = "${var.RESOURCE_PREFIX}-CognitoUserPoolClientSettingsBackingFn"
  role             = "${var.LAMBDA_COGNITO_USERPOOL_CLIENT_SETTING_ROLE_ARN}"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambda_cognito_userpool_client_settings_function.output_base64sha256}"
  runtime          = "nodejs12.x"
  timeout          = "300"
  layers           = ["${aws_lambda_layer_version.lambda-common-layer.arn}"]
}


resource "aws_lambda_function" "lambda_cognito_userpool_domain_function" {
  provider            = aws.src
  filename         = "${path.module}/zip/cfn-cognito-user-pools-domain.zip"
  function_name    = "${var.RESOURCE_PREFIX}-CognitoUserPoolDomainBackingFn"
  role             = "${var.LAMBDA_COGNITO_USERPOOL_DOMAIN_ROLE_ARN}"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambda_cognito_userpool_domain_function.output_base64sha256}"
  runtime          = "nodejs12.x"
  timeout          = "300"
  layers           = ["${aws_lambda_layer_version.lambda-common-layer.arn}"]
}

resource "aws_lambda_function" "lambda_dump_v3_account_data_function" {
  provider            = aws.src
  filename         = "${path.module}/zip/dump-v3-account-data.zip"
  function_name    = "${var.RESOURCE_PREFIX}-DumpV3AccountDataFn"
  role             = "${var.LAMBDA_DUMP_V3_ACCOUNT_ROLE_ARN}"
  handler          = "index.handler"
  memory_size      = 512
  source_code_hash = "${data.archive_file.lambda_dump_v3_account_data_function.output_base64sha256}"
  runtime          = "nodejs12.x"
  timeout          = "300"
  layers           = ["${aws_lambda_layer_version.lambda-common-layer.arn}"]
  environment {
    variables = {
      "UserPoolId"         = "${var.USERPOOL_ID}"
      "CustomersTableName" = "${var.CUSTOMER_TABLE_NAME}"
      "AdminGroupName"     = "${var.ADMIN_GROUP_NAME}"
    }
  }
}

resource "aws_lambda_function" "lambda_user_group_importer_function" {
  provider            = aws.src
  filename         = "${path.module}/zip/user-group-importer.zip"
  function_name    = "${var.RESOURCE_PREFIX}-UserGroupImporter"
  role             = "${var.LAMBDA_USERGROUP_IMPORTER_ROLE_ARN}"
  handler          = "index.handler"
  memory_size      = 512
  source_code_hash = "${data.archive_file.lambda_user_group_importer_function.output_base64sha256}"
  runtime          = "nodejs12.x"
  timeout          = "900"
  layers           = ["${aws_lambda_layer_version.lambda-common-layer.arn}"]
  environment {
    variables = {
      "UserPoolId"          = "${var.USERPOOL_ID}"
      "CustomersTableName"  = "${var.CUSTOMER_TABLE_NAME}"
      "AdminGroupName"      = "${var.ADMIN_GROUP_NAME}"
      "RegisteredGroupName" = "${var.REGISTERED_GROUP_NAME}"
      "FeedbackTable"       = "${local.FEEDBACK_TABLE_NAME}"
    }
  }
}


resource "aws_lambda_function" "lambda_api_key_authoriser_function" {
  provider            = aws.src
  filename         = "${path.module}/zip/authoriser.zip"
  function_name    = "${var.RESOURCE_PREFIX}-api-key-authoriser"
  role             = "${var.LAMBDA_USERGROUP_IMPORTER_ROLE_ARN}"
  handler          = "authoriser.handler"
  memory_size      = 512
  source_code_hash = "${data.archive_file.lambda_api_key_authoriser_function.output_base64sha256}"
  runtime          = "nodejs12.x"
  timeout          = "900"
  layers           = ["${aws_lambda_layer_version.lambda-common-layer.arn}"]
  environment {
    variables = {
      "UserPoolId"         = "${var.USERPOOL_ID}"
      "CustomersTableName" = "${var.CUSTOMER_TABLE_NAME}"

    }
  }
}


resource "aws_lambda_function" "lambda_cloudfront_security_function" {
  provider            = aws.global
  publish          = true
  filename         = "${path.module}/zip/cloudfront-security.zip"
  function_name    = "${var.RESOURCE_PREFIX}-cloudfront-security"
  role             = "${var.LAMBDA_CLOUDFRONT_SECURITY_ROLE_ARN}"
  handler          = "index.handler"
  memory_size      = 128
  source_code_hash = "${data.archive_file.lambda_cloudfront_security_function.output_base64sha256}"
  runtime          = "nodejs12.x"
  timeout          = "30"

}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [aws_lambda_function.lambda_cloudfront_security_function]

  destroy_duration = "900s"
}

resource "aws_s3_bucket_object" "upload_config_to_s3" {
  provider            = aws.src
  bucket       = "${var.WEBSITE_BUCKET_NAME}"
  key          = "config.js"
  content      = "${local.s3_config_rendered_content}"
  content_type = "application/javascript"
}
resource "aws_s3_bucket_object" "upload_sdkGeneration_to_s3" {
  provider            = aws.src
  bucket       = "${var.ARTIFACTS_S3_BUCKET_NAME}"
  key          = "sdkGeneration.json"
  content      = "${local.s3_sdkGeneration_rendered_content}"
  content_type = "application/json"
}
resource "aws_s3_bucket_object" "upload_catalog_to_s3" {
  provider            = aws.src
  bucket       = "${var.ARTIFACTS_S3_BUCKET_NAME}"
  key          = "catalog.json"
  content      = "${local.s3_catalog_rendered_content}"
  content_type = "application/json"
}