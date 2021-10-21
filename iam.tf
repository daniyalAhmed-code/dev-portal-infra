module "policy_invoke_lambda" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.5.0"
  name    = "invoke-lambda-policy"
  path    = "/"
  description = "Policy to invoke lambda"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:invokeFunction"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

module "lambda_execution_role" {
  source            = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version           = "4.5.0"
  create_role       = true
  role_name         = "apigateway-lambda-execution-role"
  role_requires_mfa = false
  trusted_role_services = [
    "apigateway.amazonaws.com"
  ]
  custom_role_policy_arns = [
    module.policy_invoke_lambda.arn
  ]
  number_of_custom_role_policy_arns = 1
}