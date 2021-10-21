
resource "aws_api_gateway_rest_api" "api-gateway" {
  name        = "${var.RESOURCE_PREFIX}-backend-api"
  description = "API to trigger lambda function."
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

resource "aws_api_gateway_resource" "admin_catalog_visibility_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.admin_catalog_resource.id
  path_part   = "visibility"
}


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
module "visibility_ANY" {
  source                          = "./methods"
  METHOD_VALUE                    = ""
  API_GATEWAY_ID                  = aws_api_gateway_rest_api.api-gateway.id
  RESOURCE_ID                     = aws_api_gateway_resource.admin_catalog_visibility_resource.id
  INTEGRATION_RESPONSE_PARAMETERS = local.integration_response_parameters
  METHOD_RESPONSE_PARAMETERS      = local.method_response_parameters
  AUTHORIZATION                   = var.AUTHORIZATION
  CURRENT_ACCOUNT_ID              = var.CURRENT_ACCOUNT_ID
  AWS_REGION                      = var.AWS_REGION
  HTTP_METHOD                     = "ANY"
  LAMBDA_INVOKE_ARN               = var.BACKEND_LAMBDA_INVOKE_ARN
  FUNCTION_NAME                   = var.BACKEND_LAMBDA_NAME

  REQUEST_TEMPLATES = {
    "application/json" = <<EOF
    EOF
  }
}




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