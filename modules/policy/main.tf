resource "aws_iam_policy" "lambda_catalog_updater_policy" {
  name = "${var.RESOURCE_PREFIX}-lambda-catalog-updater-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
        
    },
    {
      "Effect": "Allow",
      "Action": [
        "apigateway:*"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${var.WEBSITE_BUCKET_NAME}",
        "arn:aws:s3:::${var.ARTIFACTS_S3_BUCKET_NAME}"
      ]
    },
        {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::${var.ARTIFACTS_S3_BUCKET_NAME}"
      ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "lambda:InvokeFunction",
            "lambda:InvokeAsync"
        ],
        "Resource": "arn:aws:lambda:${var.AWS_REGION}:${var.CURRENT_ACCOUNT_ID}:function:${var.CATALOG_UPDATER_LAMBDA_NAME}"
    }
    
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-catalog-updater-policy-role-attachment" {
  role       = "${var.LAMBDA_CATALOG_UPDATER_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.lambda_catalog_updater_policy.arn}"
}



resource "aws_iam_policy" "lambda_backend_policy" {
  name = "${var.RESOURCE_PREFIX}-lambda-backend-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
        
    },
    {
      "Effect": "Allow",
      "Action": [
        "apigateway:*"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:PutObject"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"

      ],
      "Resource": [
        "arn:aws:dynamodb:${var.AWS_REGION}:${var.CURRENT_ACCOUNT_ID}:table/${var.CUSTOMER_TABLE_NAME}",
        "${var.PRE_LOGIN_TABLE_ARN}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:PutObject"
      ],
      "Resource": [
        "*"
      ]
    },
{
      "Effect": "Allow",
      "Action": [
        "cognito-idp:AdminListGroupsForUser"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-backend-policy-role-attachment" {
  role       = "${var.LAMBDA_BACKEND_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.lambda_backend_policy.arn}"
}




resource "aws_iam_policy" "lambda_asset_uploader_policy" {
  name = "${var.RESOURCE_PREFIX}-lambda-asset-uploader-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
        
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::${var.WEBSITE_BUCKET_NAME}/*"
      ]
    },
        {
      "Effect": "Allow",
      "Action": [
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "arn:aws:s3:::${var.WEBSITE_BUCKET_NAME}/*"
      ]
    },{
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${var.WEBSITE_BUCKET_NAME}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::${var.WEBSITE_BUCKET_NAME}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::${var.ARTIFACTS_S3_BUCKET_NAME}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${var.ARTIFACTS_S3_BUCKET_NAME}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObjet",
        "s3:Putobjet"
      ],
      "Resource": [
        "arn:aws:s3:::${var.ARTIFACTS_S3_BUCKET_NAME}/*"
      ]
    }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-asset-uploader-policy-role-attachment" {
  role       = "${var.LAMBDA_ASSET_UPLOADER_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.lambda_asset_uploader_policy.arn}"
}


//
resource "aws_iam_policy" "lambda_cognito_post_confirmation_trigger_policy" {
  name = "${var.RESOURCE_PREFIX}-lambda-cognito-post-confirmation-trigger-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
        
    },
    {
        "Effect": "Allow",
        "Action": [
          "dynamodb:PutItem"
        ],
        "Resource": "${var.PRE_LOGIN_TABLE_ARN}"
        
    },
        {
        "Effect": "Allow",
        "Action": [
          "cognito-idp:AdminAddUserToGroup"
        ],
        "Resource": "${var.COGNITO_USER_POOL}"
        
    }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-cognito-post-confirmation-trigger-policy-role-attachment" {
  role       = "${var.LAMBDA_COGNITO_POST_CONFIRMATION_TRIGGER_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.lambda_cognito_post_confirmation_trigger_policy.arn}"
}

//
resource "aws_iam_policy" "lambda_cognito_post_authentication_trigger_policy" {
  name = "${var.RESOURCE_PREFIX}-lambda-cognito-post-authentication-trigger-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
        
    },
    {
        "Effect": "Allow",
        "Action": [
          "dynamodb:PutItem",
          "dynamodb:Scan"
        ],
        "Resource": "${var.CUSTOMER_TABLE_ARN}"
        
    },
        {
        "Effect": "Allow",
        "Action": [
          "dynamodb:GetItem",
          "dynamodb:PutItem"
        ],
        "Resource": "${var.PRE_LOGIN_TABLE_ARN}"
    },
        {
        "Effect": "Allow",
        "Action": [
          "cognito-idp:AdminAddUserToGroup"
        ],
        "Resource": "${var.COGNITO_USER_POOL}"
        
    }
   ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "lambda-cognito-post-authentication-trigger-policy-role-attachment" {
  role       = "${var.LAMBDA_COGNITO_POST_AUTHENTICATION_TRIGGER_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.lambda_cognito_post_authentication_trigger_policy.arn}"
}

//
resource "aws_iam_policy" "lambda_cognito_userpool_client_setting_policy" {
  name = "${var.RESOURCE_PREFIX}-lambda-cognito-userpool-client-setting-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
        
    },
    {
        "Effect": "Allow",
        "Action": [
          "dynamodb:PutItem"
        ],
        "Resource": "${var.PRE_LOGIN_TABLE_ARN}"
        
    },
        {
        "Effect": "Allow",
        "Action": [
          "cognito-idp:AdminAddUserToGroup"
        ],
        "Resource": "${var.COGNITO_USER_POOL}"
        
    }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-cognito-userpool-client-setting-policy-role-attachment" {
  role       = "${var.LAMBDA_COGNITO_USERPOOL_CLIENT_SETTING_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.lambda_cognito_presignup_trigger_policy.arn}"
}

//
resource "aws_iam_policy" "lambda_cognito_presignup_trigger_policy" {
  name = "${var.RESOURCE_PREFIX}-lambda-cognito-presignup-trigger-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
    },
    {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
    }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-cognito-presignup-trigger-policy-role-attachment" {
  role       = "${var.LAMBDA_COGNITO_PRESIGNUP_TRIGGER_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.lambda_cognito_presignup_trigger_policy.arn}"
}


//CognitoUserPoolDomian
resource "aws_iam_policy" "manage_user_pool_domain" {
  name = "ManageUserPoolDomain"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
          "cognito-idp:CreateUserPoolDomain"
        ],
        "Resource": "arn:aws:cognito-idp:*:*:userpool/*"
        
    },
    {
        "Effect": "Allow",
        "Action": [
          "cognito-idp:DeleteUserPoolDomain"
        ],
        "Resource": "arn:aws:cognito-idp:*:*:userpool/*"
        
    },
    {
        "Effect": "Allow",
        "Action": [
          "cognito-idp:DescribeUserPoolDomain"
        ],
        "Resource": "*"
        
    }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cognito-userpool-domain-manage-user-pool-policy-role-attachment" {
  role       = "${var.LAMBDA_COGNITO_USERPOOL_DOMAIN_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.manage_user_pool_domain.arn}"
}
resource "aws_iam_role_policy_attachment" "cognito-userpool-domain-write-cloudwatch-policy-role-attachment" {
  role       = "${var.LAMBDA_COGNITO_USERPOOL_DOMAIN_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.write_cloudwatch_logs_policy.arn}"
}

// DUMP V3 Account DATA
resource "aws_iam_policy" "read_customer_table_policy" {
  name = "ReadCustomersTable"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
          "dynamodb:Scan"
        ],
        "Resource": "${var.CUSTOMER_TABLE_ARN}"
        
    }
   ]
}
EOF
}


resource "aws_iam_policy" "list_user_pool_policy" {
  name = "ReadCognitoCustomersTable"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
          "cognito-idp:ListUsers",
          "cognito-idp:ListUsersInGroup"
        ],
        "Resource": "${var.COGNITO_USER_POOL}"
        
    }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "dump-v3-account-read-customer-table-policy-role-attachment" {
  role       = "${var.LAMBDA_DUMP_V3_ACCOUNT_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.read_customer_table_policy.arn}"
}
resource "aws_iam_role_policy_attachment" "dump-v3-account-write-cloud-watchlog-policy-role-attachment" {
  role       = "${var.LAMBDA_DUMP_V3_ACCOUNT_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.write_cloudwatch_logs_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "dump-v3-list-user-pool-policy-role-attachment" {
  role       = "${var.LAMBDA_DUMP_V3_ACCOUNT_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.list_user_pool_policy.arn}"
}

// UserGroupImporter Polocies
resource "aws_iam_policy" "write_cloudwatch_logs_policy" {
  name = "WriteCloudWatchLogs"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
        
    }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-write-cloudwatch-logs-role-attachment" {
  role       = "${var.LAMBDA_USERGROUP_IMPORTER_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.write_cloudwatch_logs_policy.arn}"
}

resource "aws_iam_policy" "lambda_s3_get_object_policy" {
  name = "S3GetObject"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
          "s3:getObject"
        ],
        "Resource": "arn:aws:s3:::*/*"
        
    }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-s3-get-objects-role-attachment" {
  role       = "${var.LAMBDA_USERGROUP_IMPORTER_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.lambda_s3_get_object_policy.arn}"
}

# resource "aws_iam_policy" "lambda_restore_tables_policy" {
#   name = "RestoreTables"
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#         "Effect": "Allow",
#         "Action": [
#           "dynamodb:Scan"
#         ],
#         "Resource": [
        
#         ]"arn:aws:s3:::*/*"
        
#     }
#    ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "lambda-write-cloudwatch-logs-role-attachment" {
#   role       = "${var.LAMBDA_USERGROUP_IMPORTER_ROLE_NAME}"
#   policy_arn = "${aws_iam_policy.lambda_s3_get_object_policy.arn}"
# }


resource "aws_iam_policy" "update_cognito_user_list_policy" {
  name = "CognitoUserGroup"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
          "cognito-idp:AdminCreateUser",
          "cognito-idp:AdminCreateUserToGroup"
        ],
        "Resource":"${var.COGNITO_USER_POOL}"
        
    }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "update-config-user-s3-get-objects-role-attachment" {
  role       = "${var.LAMBDA_USERGROUP_IMPORTER_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.update_cognito_user_list_policy.arn}"
}



# Lambda Permissions
resource "aws_lambda_permission" "pre_signup_lambda_permission" {
  function_name = "${var.LAMBDA_COGNITO_PRE_SIGNUP_NAME}"
  statement_id  = "${var.LAMBDA_COGNITO_PRE_SIGNUP_NAME}-lambda-permission"
  action        = "lambda:InvokeFunction"
  principal     = "cognito-idp.amazonaws.com"
  source_arn = "arn:aws:cognito-idp:${var.AWS_REGION}:${var.CURRENT_ACCOUNT_ID}:userpool/${var.USERPOOL_ID}"
  
}
resource "aws_lambda_permission" "post_confirmation_lambda_permission" {
  function_name = "${var.LAMBDA_COGNITO_POST_CONFIRMATION_NAME}"
  statement_id  = "${var.LAMBDA_COGNITO_POST_CONFIRMATION_NAME}-lambda-permission"
  action        = "lambda:InvokeFunction"
  principal     = "cognito-idp.amazonaws.com"
  source_arn = "arn:aws:cognito-idp:${var.AWS_REGION}:${var.CURRENT_ACCOUNT_ID}:userpool/${var.USERPOOL_ID}"  
}
resource "aws_lambda_permission" "post_authentication_lambda_permission" {
  function_name = "${var.LAMBDA_COGNITO_POST_AUTHENTICATION_NAME}"
  statement_id  = "${var.LAMBDA_COGNITO_POST_AUTHENTICATION_NAME}-lambda-permission"
  action        = "lambda:InvokeFunction"
  principal     = "cognito-idp.amazonaws.com"
  source_arn = "arn:aws:cognito-idp:${var.AWS_REGION}:${var.CURRENT_ACCOUNT_ID}:userpool/${var.USERPOOL_ID}"
  
}
resource "aws_lambda_permission" "cloudfront_security_lambda_permission" {
  function_name = "${var.LAMBDA_CLOUDFRONT_SECURITY}"
  statement_id  = "${var.LAMBDA_CLOUDFRONT_SECURITY}-lambda-permission"
  action        = "lambda:GetFunction"
  principal     = "replicator.lambda.amazonaws.com"  
}



//Cognito Admin group Policy

resource "aws_iam_policy" "cognito_admin_group_policy" {
  name = "CognitoAdminRole"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
          "execute-api:Invoke"
        ],
        "Resource": "${var.API_GATEWAY_API}/prod/*/*"
    }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cognito-admin-group-policy-role-attachment" {
  role       = "${var.COGNITO_ADMIN_GROUP_ROLE}"
  policy_arn = "${aws_iam_policy.cognito_admin_group_policy.arn}"
}

//Cognito Registered group Policy


resource "aws_iam_policy" "cognito_registered_group_policy" {
  name = "CognitoRegisteredRole"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
          "execute-api:Invoke"
        ],
        "Resource": "${var.API_GATEWAY_API}/prod/*"
    },
    {
        "Effect": "Deny",
        "Action": [
          "execute-api:Invoke"
        ],
        "Resource": "${var.API_GATEWAY_API}/prod/*/admin/*"
    }

   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cognito-registered-group-policy-role-attachment" {
  role       = "${var.COGNITO_REGISTERED_GROUP_ROLE}"
  policy_arn = "${aws_iam_policy.cognito_registered_group_policy.arn}"
}


resource "aws_iam_policy" "cloudfront_security_policy" {
  name = "Cloudfront-security"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
           "lambda:CreateFunction",
            "lambda:GetFunction",
            "lambda:UpdateFunctionCode",
            "lambda:PublishVersion"
        ],
        "Resource": "arn:aws:lambda:*:*:*"
    },
    {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
    {
        "Effect": "Allow",
        "Action": [
          "iam:PassRole"
        ],
        "Resource": "arn:aws:iam::${var.CURRENT_ACCOUNT_ID}:role/*"
    },
    {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutObject"
        ],
        "Resource": "arn:aws:s3:::${var.ARTIFACTS_S3_BUCKET_NAME}/*"
    }

   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cloudfront-security-policy-role-attachment" {
  role       = "${var.LAMBDA_CLOUDFRONT_SECURITY_ROLE}"
  policy_arn = "${aws_iam_policy.cloudfront_security_policy.arn}"
}

resource "aws_s3_bucket_policy" "bucekt_policy" {
  bucket = var.WEBSITE_BUCKET_NAME

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy  = jsonencode({
 Version = "2012-10-17"
    Id ="Policy1632784971110",
    Statement = [
      {Effect = "Allow",
          Principal = {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${var.ORIGIN_ACCESS_IDENTITY}"
            },
            Action = "s3:*",
        Resource = [ "arn:aws:s3:::${var.WEBSITE_BUCKET_NAME}/*"]  
  }
  ]
 }) 

}





