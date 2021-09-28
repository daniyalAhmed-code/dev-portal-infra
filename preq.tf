data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "terraform_remote_state" "vap-platform-api" {
  backend   = "s3"
  config = {
    bucket         = "dani-dev-terraform-remote-state-centralised" 
    region         = "us-east-1" 
    key            = "vap-api-platform/prod/terraform.tfstate" 
  }
}
