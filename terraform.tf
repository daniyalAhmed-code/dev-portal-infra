terraform { 
  backend "s3" { 
    bucket         = "vap-terraform-remote-state-centralised" 
    dynamodb_table = "vap-terraform-locks-centralised" 
    region         = "us-east-1" 
    key            = "vap-api/{{ENV}}/terraform.tfstate" 
  }
}