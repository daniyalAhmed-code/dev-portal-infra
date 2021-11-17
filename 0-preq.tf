locals {
  RESOURCE_PREFIX                 = "vap-${lower(var.ENV)}"
  DEV_PORTAL_SITE_S3_BUCKET       = data.terraform_remote_state.vap-platform-infra.outputs.DEV_PORTAL_SITE_S3_BUCKET_NAME
  ARTIFICATS_S3_BUCKET            = data.terraform_remote_state.vap-platform-infra.outputs.ARTIFACT_S3_BUCKET_NAME
  DEV_PORTAL_CUSTOMERS_TABLE_NAME = data.terraform_remote_state.vap-platform-infra.outputs.DEV_PORTAL_CUSTOMERS_TABLE_NAME
  DEV_PORTAL_CUSTOMERS_TABLE_ARN  = data.terraform_remote_state.vap-platform-infra.outputs.DEV_PORTAL_CUSTOMERS_TABLE_ARN

  DEV_PORTAL_FEEDBACK_TABLE_NAME = data.terraform_remote_state.vap-platform-infra.outputs.DEV_PORTAL_FEEDBACK_TABLE_NAME
  DEV_PORTAL_FEEDBACK_TABLE_ARN  = data.terraform_remote_state.vap-platform-infra.outputs.DEV_PORTAL_FEEDBACK_TABLE_ARN

  DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME = data.terraform_remote_state.vap-platform-infra.outputs.DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME
  DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_ARN  = data.terraform_remote_state.vap-platform-infra.outputs.DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_ARN
  BUCKET_REGIONAL_DOMAIN_NAME              = data.terraform_remote_state.vap-platform-infra.outputs.BUCKET_REGIONAL_DOMAIN_NAME
  TOPIC_NAME                               = data.terraform_remote_state.vap-platform-infra.outputs.TOPIC_NAME
  COGNITO_USER_POOL                        = "${local.RESOURCE_PREFIX}-user-pool"
  COGNITO_USER_POOL_CLIENT                 = "${local.RESOURCE_PREFIX}-user-pool-client"

  ENABLE_FEEDBACK_SUBMISSION = var.ENABLE_FEEDBACK_SUBMISSION == "admin@email.com" ? local.TOPIC_NAME : ""
  IS_ADMIN                   = var.ENABLE_FEEDBACK_SUBMISSION == "admin@email.com" ? true : false

  USE_CUSTOM_DOMAIN_NAME = var.CUSTOM_DOMAIN_NAME != "" && var.ACM_CERTIFICATE_ARN != "" ? "https://${var.CUSTOM_DOMAIN_NAME}" : null
  CORS_ALLOW_ORIGIN      = "*"
  AWS_REGION             = data.aws_region.current.name
  CURRENT_ACCOUNT_ID     = data.aws_caller_identity.current.account_id

  REGISTERED_GROUP_NAME = "${local.RESOURCE_PREFIX}-registered-group"
  ADMIN_GROUP_NAME      = "${local.RESOURCE_PREFIX}-admin-group"

  # global_waf_id   = data.terraform_remote_state.vap-platform-infra.outputs.global_waf_id
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "terraform_remote_state" "vap-platform-infra" {
  backend = "s3"
  config = {
    bucket                      = "dani-dev-terraform-remote-state-centralised"
    key                         = "vap-platform-infra/us-east-1/{{ENV}}/terraform.tfstate"
    region                      = "us-east-1"
  }
}
