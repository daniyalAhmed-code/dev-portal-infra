output "LAMBDA_CATALOG_UPDATER_ROLE_NAME"{
    value = aws_iam_role.lambda_catalog_updater_role.name
}
output "LAMBDA_CATALOG_UPDATER_ROLE_ARN"{
    value = aws_iam_role.lambda_catalog_updater_role.arn
}

output "LAMBDA_BACKEND_ROLE_NAME"{
    value = aws_iam_role.lambda_backend_role.name
}
output "LAMBDA_BACKEND_ROLE_ARN"{
    value = aws_iam_role.lambda_backend_role.arn
}

output "LAMBDA_ASSET_UPLOADER_ROLE_NAME"{
    value = aws_iam_role.lambda_backend_role.name
}
output "LAMBDA_ASSET_UPLOADER_ROLE_ARN"{
    value = aws_iam_role.lambda_backend_role.arn
}

output "LAMBDA_COGNITO_PRESIGNUP_TRIGGER_ROLE_NAME"{
    value = aws_iam_role.lambda_cognito_presignup_trigger_role.name
}
output "LAMBDA_COGNITO_PRESIGNUP_TRIGGER_ROLE_ARN"{
    value = aws_iam_role.lambda_cognito_presignup_trigger_role.arn
}

output "LAMBDA_COGNITO_POST_CONFIRMATION_TRIGGER_ROLE_NAME"{
    value = aws_iam_role.lambda_cognito_presignup_trigger_role.name
}
output "LAMBDA_COGNITO_POST_CONFIRMATION_TRIGGER_ROLE_ARN"{
    value = aws_iam_role.lambda_cognito_presignup_trigger_role.arn
}

output "LAMBDA_COGNITO_POST_AUTHENTICATION_TRIGGER_ROLE_NAME"{
    value = aws_iam_role.lambda_cognito_post_authentication_trigger_role.name
}
output "LAMBDA_COGNITO_POST_AUTHENTICATION_TRIGGER_ROLE_ARN"{
    value = aws_iam_role.lambda_cognito_post_authentication_trigger_role.arn
}

output "LAMBDA_COGNITO_USERPOOL_CLIENT_SETTING_ROLE_NAME"{
    value = aws_iam_role.lambda_cognito_userpool_client_settings_role.name
}
output "LAMBDA_COGNITO_USERPOOL_CLIENT_SETTING_ROLE_ARN"{
    value = aws_iam_role.lambda_cognito_userpool_client_settings_role.arn
}

output "LAMBDA_COGNITO_USERPOOL_DOMAIN_ROLE_NAME"{
    value = aws_iam_role.lambda_cognito_userpool_domain_role.name
}
output "LAMBDA_COGNITO_USERPOOL_DOMAIN_ROLE_ARN"{
    value = aws_iam_role.lambda_cognito_userpool_domain_role.arn
}

output "LAMBDA_DUMP_V3_ACCOUNT_ROLE_NAME"{
    value = aws_iam_role.lambda_dump_v3_account_role.name
}
output "LAMBDA_DUMP_V3_ACCOUNT_ROLE_ARN"{
    value = aws_iam_role.lambda_dump_v3_account_role.arn
}

output "LAMBDA_USERGROUP_IMPORTER_ROLE_NAME"{
    value = aws_iam_role.lambda_usergroup_importer_role.name
}
output "LAMBDA_USERGROUP_IMPORTER_ROLE_ARN"{
    value = aws_iam_role.lambda_usergroup_importer_role.arn
}

output "COGNITO_ADMIN_GROUP_ROLE_NAME"{
    value = aws_iam_role.cognito_admin_group_role.name
}
output "COGNITO_ADMIN_GROUP_ROLE_ARN"{
    value = aws_iam_role.cognito_admin_group_role.arn
}

output "COGNITO_REGISTERED_GROUP_ROLE_NAME"{
    value = aws_iam_role.cognito_registered_group_role.name
}
output "COGNITO_REGISTERED_GROUP_ROLE_ARN"{
    value = aws_iam_role.cognito_registered_group_role.arn
}
output "CLOUDFRONT_SECURITY_ROLE_ARN"{
    value = aws_iam_role.lambda_cloudfront_security_role.arn
}
output "CLOUDFRONT_SECURITY_ROLE_NAME"{
    value = aws_iam_role.lambda_cloudfront_security_role.name
}