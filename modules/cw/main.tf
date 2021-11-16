## Evaluate Customer For Exception ###

resource "aws_cloudwatch_event_rule" "trigger_api_key_rotation" {
    name = "${var.RESOURCE_PREFIX}-api-key-rotation-cw"
    description = "Fires ${var.RESOURCE_PREFIX}-api-key-rotation"
    schedule_expression = "${var.API_KEY_ROTATION_TRIGGER_FREQUENCY}"
    lifecycle {
        ignore_changes = [
            "schedule_expression"
        ]
    }
}

resource "aws_cloudwatch_event_target" "target_api_key_rotation" {
    rule = "${aws_cloudwatch_event_rule.trigger_api_key_rotation.name}"
    target_id = "${var.API_KEY_ROTATION_LAMBDA_NAME}"
    arn = "${var.API_KEY_ROTATION_LAMBDA_INVOKE_ARN}"
}

resource "aws_lambda_permission" "traverse_cust_for_exception_permission" {
    statement_id = "api-key-rotation"
    action = "lambda:InvokeFunction"
    function_name = "${var.API_KEY_ROTATION_LAMBDA_NAME}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.trigger_api_key_rotation.arn}"
}


resource "aws_lambda_permission" "traverse_cust_for_exception_permission" {
    statement_id = "api-invoke-key-rotation"
    action = "lambda:InvokeFunction"
    function_name = "${var.API_KEY_ROTATION_LAMBDA_NAME}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.trigger_api_key_rotation.arn}"
}