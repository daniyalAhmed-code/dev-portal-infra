# Global
variable "env" {
  description = "Environment"
  type        = string
}

## API
variable "name" {
  description = "API Gateway name"
  type        = string
}

variable "description" {
  description = "API description"
  type        = string
}

## Swagger file
variable "swagger_file" {
  description = "Path to the swagger file"
  type        = string
  default     = ""
}

variable "swagger_vars" {
  description = "Map with the variables to be included in the swagger file"
  type        = map(string)
}

## Lambda
variable "lambda_functions_names" {
  description = "List of lambda functions names to be integrated with API Gateway"
  type        = list(string)
  default     = []
}

## WAF
variable "waf_acl_id" {
  description = "WAF ID to add to the API Gateway"
  type        = string
  default     = ""
}
