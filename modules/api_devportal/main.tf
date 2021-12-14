
resource "aws_api_gateway_rest_api" "api-gateway" {
  name        = "${var.RESOURCE_PREFIX}-backend-api"
  description = "API to trigger lambda function."
}

resource "aws_api_gateway_base_path_mapping" "api-gateway-base-path-mapping" {
  count       = var.APIGATEWAY_CUSTOM_DOMAIN_NAME != "" ? 1 : 0
  api_id      = "${aws_api_gateway_rest_api.api-gateway.id}"
  stage_name  = "${aws_api_gateway_deployment.api-gateway-deployment.stage_name}"
  domain_name = var.APIGATEWAY_CUSTOM_DOMAIN_NAME
}

resource "aws_api_gateway_resource" "version_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "version"
}

resource "aws_api_gateway_resource" "version_number_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.version_resource.id
  path_part   = "{v4_1_0}"
}

module "version_resource_OPTION" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.version_number_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  HTTP_METHOD                     = "OPTIONS"
  AUTHORIZATION                   = "NONE"
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
}

//ROOT resources
module "root_resource_OPTION" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_rest_api.api-gateway.root_resource_id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  HTTP_METHOD                     = "OPTIONS"
  AUTHORIZATION                   = "NONE"
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
}


module "root_resource" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_rest_api.api-gateway.root_resource_id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "ANY"
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}



// REGISTER POST API GATEWAY

resource "aws_api_gateway_resource" "register_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "register"
}

module "register_resource_OPTION" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.register_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  HTTP_METHOD                     = "OPTIONS"
  AUTHORIZATION                   = "NONE"
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
}

module "register" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.register_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "POST"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}

// REGISTER POST API END



//CATALOG POST API STARTS
resource "aws_api_gateway_resource" "catalog_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "catalog"
}

module "catalog_resource_OPTION" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.catalog_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  HTTP_METHOD                     = "OPTIONS"
  AUTHORIZATION                   = "NONE"
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

}

module "catalog" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.catalog_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "GET"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}
//CATALOG POST API ENDS


//Feedback POST API STARTS
resource "aws_api_gateway_resource" "feedback_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "feedback"
}


module "feedback_resource_OPTION" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.feedback_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  HTTP_METHOD                     = "OPTIONS"
  AUTHORIZATION                   = "NONE"
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
}

module "feedback_get" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.feedback_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "GET"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}
module "feedback_post" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.feedback_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "POST"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}
module "feedback_delete" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.feedback_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
  HTTP_METHOD                     = "DELETE"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}


//FEEDBACK API ENDS

// catalog visibility api starts

resource "aws_api_gateway_resource" "admin_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "admin"
}

resource "aws_api_gateway_resource" "admin_catalog_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.admin_resource.id
  path_part   = "catalog"
}

resource "aws_api_gateway_resource" "admin_account_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.admin_resource.id
  path_part   = "accounts"
}

resource "aws_api_gateway_resource" "admin_account_callback_auth_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.admin_resource.id
  path_part   = "callbackAuth"
}

resource "aws_api_gateway_resource" "admin_account_userid_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.admin_account_resource.id
  path_part   = "{userId}"
}

resource "aws_api_gateway_resource" "admin_account_resend_invite_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.admin_account_resource.id
  path_part   = "resendInvite"
}

resource "aws_api_gateway_resource" "admin_account_current_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.admin_account_resource.id
  path_part   = "current"
}

resource "aws_api_gateway_resource" "admin_account_user_profile_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.admin_account_current_resource.id
  path_part   = "getUserProfile"
}




resource "aws_api_gateway_resource" "admin_account_profile_image_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.admin_resource.id
  path_part   = "profileImage"
}

resource "aws_api_gateway_resource" "admin_account_profile_image_user_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.admin_account_profile_image_resource.id
  path_part   = "{userId}"
}



resource "aws_api_gateway_resource" "promote_to_admin_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.admin_account_userid_resource.id
  path_part   = "promoteToAdmin"
}


resource "aws_api_gateway_resource" "admin_catalog_visibility_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.admin_catalog_resource.id
  path_part   = "visibility"
}

//visibility here

module "visibility_resource_OPTION" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.admin_catalog_visibility_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  HTTP_METHOD                     = "OPTIONS"
  AUTHORIZATION                   = "NONE"
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
}

module "visibility_get" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.admin_catalog_visibility_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "GET"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}
module "visibility_post" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.admin_catalog_visibility_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
  HTTP_METHOD                     = "POST"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}

# module "visibility_ANY" {
#   source                          = "./methods"
#   METHOD_VALUE                    = ""
#   API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
#   RESOURCE_ID                     = aws_api_gateway_resource.admin_catalog_visibility_resource.id
#   INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
#   METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
#   AUTHORIZATION                   = var.AUTHORIZATION
#   CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
#   AWS_REGION                      = var.AWS_REGION
#   HTTP_METHOD                     = "ANY"
#   LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
#   FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME

#   REQUEST_TEMPLATES = {
#     "application/json" = <<EOF
#     EOF
#   }
# }




//catalog visibility api ends

//proxy api starts


resource "aws_api_gateway_resource" "proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "{proxy+}"
}
module "proxy_post" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.proxy_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = {}
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
  HTTP_METHOD                     = "ANY"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
}



module "proxy_resource_OPTION" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.proxy_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
  HTTP_METHOD                     = "OPTIONS"
  AUTHORIZATION                   = "NONE"
}

//proxy api ends

//NEW APIS

//SIGN IN 
resource "aws_api_gateway_resource" "sigin_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "signin"
}

module "siginin_resource_OPTION" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.sigin_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  HTTP_METHOD                     = "OPTIONS"
  AUTHORIZATION                   = "NONE"
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
}

module "signin_post" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.sigin_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  HTTP_METHOD                     = "POST"
  AUTHORIZATION                   = "NONE"
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
}


//APIKEY
resource "aws_api_gateway_resource" "apikey_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "apikey"
}

module "apiKey_resource_OPTION" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.apikey_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  HTTP_METHOD                     = "OPTIONS"
  AUTHORIZATION                   = "NONE"
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
}

module "apikey_get" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.apikey_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  HTTP_METHOD                     = "GET"
  AUTHORIZATION                   = "NONE"
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
}


//Subscription

resource "aws_api_gateway_resource" "subscription_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "subscription"
}

resource "aws_api_gateway_resource" "usageplan_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.subscription_resource.id
  path_part   = "{usageplanId}"
}

resource "aws_api_gateway_resource" "usage_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.usageplan_resource.id
  path_part   = "usage"
}



module "usagePlanId_put" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.usageplan_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  HTTP_METHOD                     = "PUT"
  AUTHORIZATION                   = "NONE"
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
}

module "usagePlanId_delete" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.usageplan_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  HTTP_METHOD                     = "DELETE"
  AUTHORIZATION                   = "NONE"
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
}

module "usage_get" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.usage_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  HTTP_METHOD                     = "GET"
  AUTHORIZATION                   = "NONE"
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
}

//CATALOG

resource "aws_api_gateway_resource" "catalog_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id  = aws_api_gateway_resource.catalog_resource.id
  path_part   = "{id}"
}
resource "aws_api_gateway_resource" "catalog_id_sdk_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id  = aws_api_gateway_resource.catalog_id_resource.id
  path_part   = "sdk"
}
resource "aws_api_gateway_resource" "catalog_id_export_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id  = aws_api_gateway_resource.catalog_id_resource.id
  path_part   = "export"
}

module "sdk_get" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.catalog_id_sdk_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  HTTP_METHOD                     = "GET"
  AUTHORIZATION                   = "NONE"
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
}
module "export_get" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.catalog_id_export_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  HTTP_METHOD                     = "GET"
  AUTHORIZATION                   = "NONE"
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
}

resource "aws_api_gateway_resource" "admin_catalog_visibility_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.admin_catalog_visibility_resource.id
  path_part   = "{id}"
}
resource "aws_api_gateway_resource" "admin_catalog_visibility_id_sdkGeneration_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.admin_catalog_visibility_resource.id
  path_part   = "sdkGeneration"
}

module "visibility_delete" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.admin_catalog_visibility_id_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "DELETE"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}

module "sdkGeneration_put" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.admin_catalog_visibility_id_sdkGeneration_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "PUT"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}
module "sdkGeneration_delete" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.admin_catalog_visibility_id_sdkGeneration_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "DELETE"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}

// Admin/account


module "account_get" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.admin_account_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "GET"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}

module "account_post" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.admin_account_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "POST"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}

module "account_userid_get" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.admin_account_userid_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "GET"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}


module "account_userid_promote_to_admin" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.promote_to_admin_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "PUT"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}

module "account_userid_delete" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.admin_account_userid_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "DELETE"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}

//CallBackAuth

module "account_callbackauth" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.admin_account_callback_auth_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "POST"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}


//resend invite

module "resendInvite_post" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.admin_account_resend_invite_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "POST"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}

module "userProfile_get" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.admin_account_user_profile_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "POST"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}

module "profileImage_get" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.admin_account_profile_image_user_id_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "GET"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}

module "profileImage_put" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.admin_account_profile_image_user_id_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  HTTP_METHOD                     = "PUT"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}

### --- API Deployment Starts --- ###

resource "aws_api_gateway_deployment" "api-gateway-deployment" {
  depends_on = [
    "module.version_resource_OPTION.API_GATEWAY_METHOD",
    "module.root_resource_OPTION.API_GATEWAY_METHOD",
    "module.feedback_resource_OPTION.API_GATEWAY_METHOD",
    "module.catalog_resource_OPTION.API_GATEWAY_METHOD",
    "module.visibility_resource_OPTION.API_GATEWAY_METHOD",

    "module.proxy_resource_OPTION.API_GATEWAY_METHOD",

    "module.register_resource_OPTION.API_GATEWAY_METHOD",
    "module.register.API_GATEWAY_INTEGRATION",
    "module.register.API_GATEWAY_RESPONSE_200",


    "module.catalog.API_GATEWAY_METHOD",
    "module.catalog.API_GATEWAY_INTEGRATION",
    "module.catalog.API_GATEWAY_RESPONSE_200",

    "module.feedback_get.API_GATEWAY_METHOD",
    "module.feedback_get.API_GATEWAY_INTEGRATION",
    "module.feedback_get.API_GATEWAY_RESPONSE_200",
    "module.feedback_post.API_GATEWAY_METHOD",
    "module.feedback_post.API_GATEWAY_INTEGRATION",
    "module.feedback_post.API_GATEWAY_RESPONSE_200",

    "module.feedback_delete.API_GATEWAY_METHOD",
    "module.feedback_delete.API_GATEWAY_INTEGRATION",
    "module.feedback_delete.API_GATEWAY_RESPONSE_200",

    "module.visibility_get.API_GATEWAY_METHOD",
    "module.visibility_get.API_GATEWAY_INTEGRATION",
    "module.visibility_get.API_GATEWAY_RESPONSE_200",
    "module.visibility_post.API_GATEWAY_METHOD",
    "module.visibility_post.API_GATEWAY_INTEGRATION",
    "module.visibility_post.API_GATEWAY_RESPONSE_200",

    "module.proxy_post.API_GATEWAY_METHOD",
    "module.proxy_post.API_GATEWAY_INTEGRATION",
    "module.proxy_post.API_GATEWAY_RESPONSE_200",
  ]
  rest_api_id       = aws_api_gateway_rest_api.api-gateway.id
  stage_name        = "prod"
  stage_description = "1.0"
  description       = "1.0"

  variables = {
    "DevPortalFunctionName" = "${var.RESOURCE_PREFIX}-backend"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_authorizer" "lambda_authorizer" {
  name                   = "${var.RESOURCE_PREFIX}-lambda-authorizer"
  rest_api_id            = aws_api_gateway_rest_api.api-gateway.id
  authorizer_uri         = var.API_KEY_AUTHORIZATION_INVOKE_ARN
  authorizer_credentials = var.API_KEY_AUTHORIZATION_ROLE_ARN
}

resource "aws_lambda_permission" "lambda_permission1" {
  function_name = var.BACKEND_LAMBDA_NAME
  statement_id  = "lambda-permission1"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api-gateway.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "lambda_permission2" {
  function_name = var.BACKEND_LAMBDA_NAME
  statement_id  = "lambda-permission2"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api-gateway.execution_arn}/*/*/"
}

resource "aws_lambda_permission" "lambda_permission3" {
  function_name = var.BACKEND_LAMBDA_NAME
  statement_id  = "lambda-permission3"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api-gateway.execution_arn}/*/*"
}