ENABLE_FEEDBACK_SUBMISSION = "admin@email.com"

NAME = "vap-api"

ENV = "test"

USE_ROUTE53         = true
CUSTOM_DOMAIN_NAME  = "test.vantageapi.com"
HOSTED_ZONE_ID      = "Z04435461Z96MBNSTOO2M"
ACM_CERTIFICATE_ARN = "arn:aws:acm:us-east-1:730274447902:certificate/0660e02a-978a-462f-8e9f-fb72072334f4"

COGNITO_ADMIN_GROUP_DESCRIPTION      = "Group for Admins"
COGNITO_REGISTERED_GROUP_DESCRIPTION = "Group for registered users"
COGNITO_USER_POOL_DOMAIN             = "vapdev"
ACCOUNT_REGISTRATION_MODE            = "open"
ALLOW_ADMIN_CREATE_USER_ONLY         = false
ORIGIN_ID                            = true

DEVELOPMENT_MODE = true
NODE_ENV         = "production"
