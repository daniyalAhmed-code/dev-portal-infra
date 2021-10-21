
variable "CORS_ALLOW_ORIGIN" {
  type    = string
  default = "*"
}


variable "allow_headers" {
  description = "Allow headers"
  type        = list(string)

  default = [
    "Authorization",
    "authorization",
    "Content-Type",
    "X-Amz-Date",
    "X-Amz-Security-Token",
    "X-Api-Key",

  ]
}

# var.allow_methods
variable "allow_methods" {
  description = "Allow methods"
  type        = list(string)

  default = [
    "*",
    # "HEAD",
    # "GET",
    # "POST",
    # "PUT",
    # "PATCH",
    # "DELETE",
  ]
}

# # var.allow_origin
variable "allow_origin" {
  description = "Allow origin"
  type        = string
  default     = "*"
}

# var.allow_max_age
variable "allow_max_age" {
  description = "Allow response caching time"
  type        = string
  default     = "7200"
}

# var.allowed_credentials
variable "allow_credentials" {
  description = "Allow credentials"
  default     = true
}

##################

variable "Strict_Transport_Security" {
  default = "max-age=31536000; includeSubDomains; preload"
}

variable "Referrer_Policy" {
  default = "same-origin"
}

variable "X_XSS_Protection" {
  default = "1; mode=block"
}

variable "X_Frame_Options" {
  default = "DENY"
}

variable "X_Content_Type_Options" {
  default = "nosniff"
}

variable "Content_Security_Policy" {
  default = "default-src 'self';"
}
# variable "CORS_ALLOW_ORIGIN" {}

# variable "COMMON_TAGS" {}
variable "ENV" {}
variable "RESOURCE_PREFIX" {}
variable "CURRENT_ACCOUNT_ID" {}
variable "AWS_REGION" {}


# variable "LAMBDA_ENTITY_AUTHORIZER_INVOKE_ARN" {}
variable "AUTHORIZATION" {
  default = "AWS_IAM" // CUSTOM
}


variable "Base_Path" {
  default = "prod" //notification
}
variable "BACKEND_LAMBDA_NAME" {}
variable "BACKEND_LAMBDA_INVOKE_ARN" {}
variable "USE_CUSTOM_DOMAIN_NAME" {}
variable "DOMAIN_NAME" {}
variable "API_KEY_AUTHORIZATION_ROLE_ARN" {}
variable "API_KEY_AUTHORIZATION_INVOKE_ARN" {}