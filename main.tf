module "role" {
  source                = "./modules/role"
  COGNITO_IDENTITY_POOL = module.cognito.COGNITO_IDENTITY_POOL
  RESOURCE_PREFIX       = local.RESOURCE_PREFIX
}

module "policy" {
  source = "./modules/policy"
  providers = {
    aws.src    = aws
    aws.global = aws.global_region
  }
  CLOUDFRONT_SECURITY_LAMBDA_QUALIFIED_ARN             = module.lambda.CLOUDFRONT_SECURITY_LAMBDA_QUALIFIED_ARN
  COGNITO_USER_POOL                                    = module.cognito.COGNITO_USERPOOL_ARN
  LAMBDA_CATALOG_UPDATER_ROLE_NAME                     = module.role.LAMBDA_CATALOG_UPDATER_ROLE_NAME
  LAMBDA_BACKEND_ROLE_NAME                             = module.role.LAMBDA_BACKEND_ROLE_NAME
  LAMBDA_ASSET_UPLOADER_ROLE_NAME                      = module.role.LAMBDA_ASSET_UPLOADER_ROLE_NAME
  CUSTOMER_TABLE_ARN                                   = local.DEV_PORTAL_CUSTOMERS_TABLE_ARN
  CUSTOMER_TABLE_NAME                                  = local.DEV_PORTAL_CUSTOMERS_TABLE_NAME
  PRE_LOGIN_TABLE_ARN                                  = local.DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_ARN
  AWS_REGION                                           = local.AWS_REGION
  CURRENT_ACCOUNT_ID                                   = local.CURRENT_ACCOUNT_ID
  RESOURCE_PREFIX                                      = local.RESOURCE_PREFIX
  WEBSITE_BUCKET_NAME                                  = local.DEV_PORTAL_SITE_S3_BUCKET
  ARTIFACTS_S3_BUCKET_NAME                             = local.ARTIFICATS_S3_BUCKET
  CATALOG_UPDATER_LAMBDA_NAME                          = module.lambda.CATALOG_UPDATER_LAMBDA_NAME
  LAMBDA_COGNITO_PRESIGNUP_TRIGGER_ROLE_NAME           = module.role.LAMBDA_COGNITO_PRESIGNUP_TRIGGER_ROLE_NAME
  LAMBDA_COGNITO_POST_AUTHENTICATION_TRIGGER_ROLE_NAME = module.role.LAMBDA_COGNITO_POST_AUTHENTICATION_TRIGGER_ROLE_NAME
  LAMBDA_COGNITO_POST_CONFIRMATION_TRIGGER_ROLE_NAME   = module.role.LAMBDA_COGNITO_POST_CONFIRMATION_TRIGGER_ROLE_NAME
  LAMBDA_COGNITO_USERPOOL_CLIENT_SETTING_ROLE_NAME     = module.role.LAMBDA_COGNITO_USERPOOL_CLIENT_SETTING_ROLE_NAME
  LAMBDA_COGNITO_USERPOOL_DOMAIN_ROLE_NAME             = module.role.LAMBDA_COGNITO_USERPOOL_DOMAIN_ROLE_NAME
  LAMBDA_USERGROUP_IMPORTER_ROLE_NAME                  = module.role.LAMBDA_USERGROUP_IMPORTER_ROLE_NAME
  LAMBDA_DUMP_V3_ACCOUNT_ROLE_NAME                     = module.role.LAMBDA_DUMP_V3_ACCOUNT_ROLE_NAME
  LAMBDA_COGNITO_PRE_SIGNUP_NAME                       = module.lambda.COGNITO_PRESIGNUP_TRIGGER_LAMBDA_NAME
  LAMBDA_COGNITO_POST_CONFIRMATION_NAME                = module.lambda.COGNITO_POST_CONFIRMATION_TRIGGER_LAMBDA_NAME
  LAMBDA_COGNITO_POST_AUTHENTICATION_NAME              = module.lambda.COGNITO_POST_AUTHENTICATION_TRIGGER_LAMBDA_NAME
  LAMBDA_CLOUDFRONT_SECURITY                           = module.lambda.CLOUDFRONT_SECURITY_LAMBDA_NAME
  LAMBDA_SECURITY_HEADER                               = module.lambda.CLOUDFRONT_SECURITY_HEADER_NAME
  LAMBDA_AUTHORIZATION_ROLE_ARN                        = module.role.LAMBDA_AUTHORIZATION_ROLE_ARN
  LAMBDA_AUTHORIZATION_ROLE_NAME                       = module.role.LAMBDA_AUTHORIZATION_ROLE_NAME
  USERPOOL_ID                                          = module.cognito.COGNITO_USER_POOL
  API_GATEWAY_API                                      = module.api.API_GATEWAY_API
  COGNITO_ADMIN_GROUP_ROLE                             = module.role.COGNITO_ADMIN_GROUP_ROLE_NAME
  COGNITO_REGISTERED_GROUP_ROLE                        = module.role.COGNITO_REGISTERED_GROUP_ROLE_NAME
  LAMBDA_CLOUDFRONT_SECURITY_ROLE                      = module.role.CLOUDFRONT_SECURITY_ROLE_NAME
  ORIGIN_ACCESS_IDENTITY                               = module.cloudfront.id
  API_KEY_AUTHORIZATION_LAMBDA_ARN                     = module.lambda.API_KEY_AUTHORIZATION_LAMBDA_ARN
  API_KEY_AUTHORIZATION_ROLE_NAME                      = module.role.API_KEY_AUTHORIZATION_ROLE_NAME
  CATALOG_UPDATER_LAMBDA_ARN                           = module.lambda.CATALOG_UPDATER_LAMBDA_ARN
  COGNITO_SMS_CALLER_ROLE_NAME                         = module.role.SMS_CALLER_ROLE_NAME
  BACKEND_LAMBDA_NAME                                  = module.lambda.BACKEND_LAMBDA_NAME
  COGNITO_USERPOOL_CLIENT_SETTINGS_NAME                = module.lambda.COGNITO_USERPOOL_CLIENT_SETTINGS_NAME
  API_KEY_AUTHORIZATION_LAMBDA_NAME                    = module.lambda.API_KEY_AUTHORIZATION_LAMBDA_NAME
  API_KEY_ROTATION_LAMBDA_NAME                         = module.lambda.API_KEY_ROTATION_LAMBDA_NAME
  INVOKE_API_KEY_ROTATION_LAMBDA_NAME                  = module.lambda.INVOKE_API_KEY_ROTATION_LAMBDA_NAME
  LAMBDA_INVOKE_API_KEY_ROTATION_ROLE_NAME             = module.role.LAMBDA_INVOKE_API_KEY_ROTATION_ROLE_NAME
  LAMBDA_API_KEY_ROTATION_ROLE_NAME                    = module.role.LAMBDA_API_KEY_ROTATION_ROLE_NAME
  LAMBDA_INVOKE_API_KEY_ROTATION_ROLE_ARN              = module.role.LAMBDA_INVOKE_API_KEY_ROTATION_ROLE_ARN
  LAMBDA_API_KEY_ROTATION_ROLE_ARN                     = module.role.LAMBDA_API_KEY_ROTATION_ROLE_ARN
  API_GATEWAY_ID                                       = module.api.API_GATEWAY_ID
  
}

module "lambda" {
  source = "./modules/lambda"
  providers = {
    aws.src    = aws
    aws.global = aws.global_region
  }
  ARTIFACTS_S3_BUCKET_NAME                            = local.ARTIFICATS_S3_BUCKET
  LAMBDA_CATALOG_UPDATER_ROLE_ARN                     = module.role.LAMBDA_CATALOG_UPDATER_ROLE_ARN
  LAMBDA_BACKEND_ROLE_ARN                             = module.role.LAMBDA_BACKEND_ROLE_ARN
  LAMBDA_ASSET_UPLOADER_ROLE_ARN                      = module.role.LAMBDA_ASSET_UPLOADER_ROLE_ARN
  LAMBDA_COGNITO_PRESIGNUP_TRIGGER_ROLE_ARN           = module.role.LAMBDA_COGNITO_PRESIGNUP_TRIGGER_ROLE_ARN
  LAMBDA_COGNITO_POST_AUTHENTICATION_TRIGGER_ROLE_ARN = module.role.LAMBDA_COGNITO_POST_AUTHENTICATION_TRIGGER_ROLE_ARN
  LAMBDA_COGNITO_POST_CONFIRMATION_TRIGGER_ROLE_ARN   = module.role.LAMBDA_COGNITO_POST_CONFIRMATION_TRIGGER_ROLE_ARN
  LAMBDA_COGNITO_USERPOOL_CLIENT_SETTING_ROLE_ARN     = module.role.LAMBDA_COGNITO_USERPOOL_CLIENT_SETTING_ROLE_ARN
  LAMBDA_COGNITO_USERPOOL_DOMAIN_ROLE_ARN             = module.role.LAMBDA_COGNITO_USERPOOL_DOMAIN_ROLE_ARN
  LAMBDA_USERGROUP_IMPORTER_ROLE_ARN                  = module.role.LAMBDA_USERGROUP_IMPORTER_ROLE_ARN
  LAMBDA_DUMP_V3_ACCOUNT_ROLE_ARN                     = module.role.LAMBDA_DUMP_V3_ACCOUNT_ROLE_ARN
  LAMBDA_CLOUDFRONT_SECURITY_ROLE_ARN                 = module.role.CLOUDFRONT_SECURITY_ROLE_ARN
  LAMBDA_AUTHORIZATION_ROLE_ARN                       = module.role.LAMBDA_AUTHORIZATION_ROLE_ARN
  NODE_ENV                                            = var.NODE_ENV
  WEBSITE_BUCKET_NAME                                 = local.DEV_PORTAL_SITE_S3_BUCKET
  CUSTOMER_TABLE_NAME                                 = local.DEV_PORTAL_CUSTOMERS_TABLE_NAME
  PRE_LOGIN_ACCOUNT_TABLE_NAME                        = local.DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME
  FEEDBACK_TABLE_NAME                                 = local.DEV_PORTAL_FEEDBACK_TABLE_NAME
  FEEDBACK_SNS_TOPIC_ARN                              = local.ENABLE_FEEDBACK_SUBMISSION
  USERPOOL_ID                                         = module.cognito.COGNITO_USER_POOL
  IS_ADMIN                                            = local.IS_ADMIN
  ADMIN_GROUP_NAME                                    = local.ADMIN_GROUP_NAME
  RESOURCE_PREFIX                                     = local.RESOURCE_PREFIX
  ACCOUNT_REGISTRATION_MODE                           = var.ACCOUNT_REGISTRATION_MODE
  REGISTERED_GROUP_NAME                               = local.REGISTERED_GROUP_NAME
  DEVELOPMENT_MODE                                    = var.DEVELOPMENT_MODE ? true : false
  AWS_REGION                                          = data.aws_region.current.name
  AWS_ACCOUNT_ID                                      = local.CURRENT_ACCOUNT_ID
  API_GATEWAY_API                                     = module.api.API_GATEWAY_ID
  FEEDBACK_ENABLED                                    = local.IS_ADMIN
  USERPOOL_DOMAIN                                     = "https://${var.COGNITO_USER_POOL_DOMAIN}.auth.${data.aws_region.current.name}.amazoncognito.com"
  USERPOOL_CLIENT_ID                                  = module.cognito.COGNITO_USERPOOL_CLIENT
  IDENTITYPOOL_ID                                     = module.cognito.COGNITO_IDENTITY_POOL
  APIGATEWAY_CUSTOM_DOMAIN_NAME                       = var.APIGATEWAY_CUSTOM_DOMAIN_NAME
  LAMBDA_INVOKE_API_KEY_ROTATION_ROLE_ARN             = module.role.LAMBDA_INVOKE_API_KEY_ROTATION_ROLE_ARN
  LAMBDA_API_KEY_ROTATION_ROLE_ARN                    = module.role.LAMBDA_API_KEY_ROTATION_ROLE_ARN
}


module "api" {
  source                           = "./modules/api_devportal"
  RESOURCE_PREFIX                  = local.RESOURCE_PREFIX
  ENV                              = var.ENV
  CORS_ALLOW_ORIGIN                = local.CORS_ALLOW_ORIGIN
  BACKEND_LAMBDA_INVOKE_ARN        = module.lambda.BACKEND_LAMBDA_INVOKE_ARN
  BACKEND_LAMBDA_NAME              = module.lambda.BACKEND_LAMBDA_NAME
  USE_CUSTOM_DOMAIN_NAME           = local.USE_CUSTOM_DOMAIN_NAME
  DOMAIN_NAME                      = module.cloudfront.CLOUDFRONT_DOMAIN
  CURRENT_ACCOUNT_ID               = data.aws_caller_identity.current.account_id
  AWS_REGION                       = data.aws_region.current.name
  API_KEY_AUTHORIZATION_ROLE_ARN   = module.role.API_KEY_AUTHORIZATION_ROLE_ARN
  API_KEY_AUTHORIZATION_INVOKE_ARN = module.lambda.API_KEY_AUTHORIZATION_INVOKE_ARN
  APIGATEWAY_CUSTOM_DOMAIN_NAME    = var.APIGATEWAY_CUSTOM_DOMAIN_NAME

}

module "cloudfront" {
  source = "./modules/cloudfront"
  providers = {
    aws = aws.global_region
  }
  DEVELOPMENT_MODE                 = var.DEVELOPMENT_MODE
  RESOURCE_PREFIX                  = local.RESOURCE_PREFIX
  CUSTOM_DOMAIN_NAME               = var.CUSTOM_DOMAIN_NAME
  DEV_PORTAL_SITE_S3_BUCKET        = local.DEV_PORTAL_SITE_S3_BUCKET
  ARTIFACTS_S3_BUCKET_NAME         = local.ARTIFICATS_S3_BUCKET
  CLOUDFRONT_SECURITY_HEADER_SETUP = module.lambda.CLOUDFRONT_SECURITY_HEADER_QUALIFIED_ARN
  ORIGIN_ID                        = var.ORIGIN_ID
  AWS_REGION                       = data.aws_region.current.name
  ACM_CERTIFICATE_ARN              = var.ACM_CERTIFICATE_ARN
  BUCKET_REGIONAL_DOMAIN_NAME      = local.BUCKET_REGIONAL_DOMAIN_NAME
  # waf_acl_id                       = local.global_waf_id
}

module "route53" {
  source             = "./modules/route53"
  USE_ROUTE53        = var.USE_ROUTE53
  CUSTOM_DOMAIN_NAME = var.CUSTOM_DOMAIN_NAME
  HOSTED_ZONE_ID     = var.HOSTED_ZONE_ID
  DNS_NAME           = module.cloudfront.CLOUDFRONT_DOMAIN
}


module "cognito" {
  source                               = "./modules/cognito"
  COGNITO_USER_POOL                    = local.COGNITO_USER_POOL
  ALLOW_ADMIN_CREATE_USER_ONLY         = var.ALLOW_ADMIN_CREATE_USER_ONLY
  CUSTOM_DOMAIN_NAME                   = var.CUSTOM_DOMAIN_NAME
  AWS_REGION                           = local.AWS_REGION
  AWS_ACCOUNT_ID                       = local.CURRENT_ACCOUNT_ID
  RESOURCE_PREFIX                      = local.RESOURCE_PREFIX
  COGNITO_USER_POOL_CLIENT             = local.COGNITO_USER_POOL_CLIENT
  COGNITO_ADMIN_GROUP_DESCRIPTION      = var.COGNITO_ADMIN_GROUP_DESCRIPTION
  COGNITO_REGISTERED_GROUP_DESCRIPTION = var.COGNITO_REGISTERED_GROUP_DESCRIPTION
  COGNITO_USER_POOL_DOMAIN             = var.COGNITO_USER_POOL_DOMAIN
  DNS_NAME                             = module.cloudfront.CLOUDFRONT_DOMAIN
  REGISTERED_GROUP_NAME                = local.REGISTERED_GROUP_NAME
  ADMIN_GROUP_NAME                     = local.ADMIN_GROUP_NAME
  # LOCAL_DEVELOPMENT_MODE = var.LOCAL_DEVELOPMENT_MODE
  COGNITO_REGISTERED_GROUP_ROLE_ARN = module.role.COGNITO_REGISTERED_GROUP_ROLE_ARN
  COGNITO_ADMIN_GROUP_ROLE_ARN      = module.role.COGNITO_ADMIN_GROUP_ROLE_ARN
  COGNITO_SMS_CALLER_ROLE_ARN       = module.role.SMS_CALLER_ROLE_ARN
  # BUCEKT_REGIONAL_DOMAIN_NAME = var.BUCKET_REGIONAL_NAME
}

module "cw" {
  source = "./modules/cw"
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
  API_KEY_ROTATION_TRIGGER_FREQUENCY = var.API_KEY_ROTATION_TRIGGER_FREQUENCY
  API_KEY_ROTATION_LAMBDA_INVOKE_ARN       = module.lambda.API_KEY_ROTATION_LAMBDA_INVOKE_ARN
  API_KEY_ROTATION_LAMBDA_NAME              = module.lambda.API_KEY_ROTATION_LAMBDA_NAME
}

### API ###

resource "aws_api_gateway_account" "this" {
  depends_on          = [aws_iam_role.api_gateway_cloudwatch]
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch.arn
}

resource "aws_iam_role" "api_gateway_cloudwatch" {
  name               = "api-gateway-cloudwatch-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "api_gateway_cloudwatch" {
  name = "api-gateway-cloudwatch-policy"
  role = aws_iam_role.api_gateway_cloudwatch.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "arn:aws:logs:${local.AWS_REGION}:${local.CURRENT_ACCOUNT_ID}:log-group:*:*"
        }
    ]
}
EOF
}
