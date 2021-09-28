
variable "ENABLE_FEEDBACK_SUBMISSION"{
    type = string
    default = "admin@email.com"    
}


variable "DEVELOPMENT_MODE"{
    type = bool
    default = true
}


# variable "LOCAL_DEVELOPMENT_MODE"{
#     type = bool
#     default = false
# }


variable "NODE_ENV"{
    type = string
    default = "production"
}

variable "ENV"{
    type = string
    default = "dev-prod"
}
variable "ACCOUNT_REGISTRATION_MODE"{
    type = string
    default = "open"
}

variable "CUSTOM_DOMAIN_NAME"{
    type = string
    default = ""
}

variable "CUSTOM_DOMAIN_NAME_ACM_CERT_ARN"{
    type = string
    default = "arn:aws:acm:us-east-1:489994096722:certificate/26d0ae3d-67f4-4b14-9ce9-e2db857974ca"
}
variable "COGNITO_ADMIN_GROUP_DESCRIPTION"{
    default = "Group for Admins"
}
variable "COGNITO_REGISTERED_GROUP_DESCRIPTION"{
    default = "Group for registered users"
}

variable "HOSTED_ZONE_ID"{
    default = "Z074130239BXW7W2J0TY9"
}
variable "USE_ROUTE53"{
    default = true
}

variable "ORIGIN_ID"{
    default = true
}
variable "ACM_CERTIFICATE_ARN"{
    default = "arn:aws:acm:us-east-1:xxxxxx:certificate/26d0ae3d-67f4-4b14-9ce9-e2db857974ca"
}  

variable "COGNITO_USER_POOL_DOMAIN"{
    default ="xxxdomain"
}


variable "SCHEMA_ATTRIBUTES" {
    default = [{
      name       = "email", # overwrites the default attribute 'gender'
      type       = "String"
      required   = true
      min_length = 1
      max_length = 2048
    }]
}

variable "ALLOW_ADMIN_CREATE_USER_ONLY"{
    default = false    

}
