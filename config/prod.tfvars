ENABLE_FEEDBACK_SUBMISSION = "admin@email.com"

NAME = "vap-api"

ENV = "prod"

USE_ROUTE53         = true
CUSTOM_DOMAIN_NAME  = "XXXXXXX"
HOSTED_ZONE_ID      = "XXXXX"
ACM_CERTIFICATE_ARN = "XXXXX"

COGNITO_ADMIN_GROUP_DESCRIPTION      = "Group for Admins"
COGNITO_REGISTERED_GROUP_DESCRIPTION = "Group for registered users"
COGNITO_USER_POOL_DOMAIN             = "vapprod"
ACCOUNT_REGISTRATION_MODE            = "open"
ALLOW_ADMIN_CREATE_USER_ONLY         = false
ORIGIN_ID                            = true

DEVELOPMENT_MODE = true
NODE_ENV         = "production"
