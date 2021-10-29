#!/bin/bash

role_arn=$2
aws s3 cp s3://vap-aws-terraform-remote-state-centralized/vap-platform-infra/$AWS_REGION/$1/terraform.tfstate .

temp_role=$(aws sts assume-role --role-arn $role_arn --role-session-name "vap-api-deploy")
export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $temp_role | jq -r .Credentials.SessionToken)

ARTIFACT_BUCKET_NAME=$(cat terraform.tfstate | jq '.outputs.ARTIFACT_S3_BUCKET_NAME.value' | tr -d '"')

catalog_file_exists=true
sdkGeneration_file_exists=true

aws s3api head-object --bucket $ARTIFACT_BUCKET_NAME --key catalog.json || catalog_file_exists=false
aws s3api head-object --bucket $ARTIFACT_BUCKET_NAME --key sdkGeneration.json || sdkGeneration_file_exists=false


if [ "$catalog_file_exists" == false ]; then
  aws s3 cp "./files/catalog.json" "s3://${ARTIFACT_BUCKET_NAME}"
fi

if [ "$sdkGeneration_file_exists" == false ]; then
  aws s3 cp "./files/sdkGeneration.json" "s3://${ARTIFACT_BUCKET_NAME}"
fi