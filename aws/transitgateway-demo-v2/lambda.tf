
resource "aws_iam_role_policy" "lambda_role_policy" {
  name        = "lambda_role_policy"
  role = "${aws_iam_role.lambda_role.id}"

  policy = "${file("./iam/lambda-policy.json")}"
}
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = "${file("./iam/lambda-assume-policy.json")}"
}

resource "aws_lambda_layer_version" "external-modules-lambda" {
  filename   = "./lambda/layer.zip"
  layer_name = "external-modules"

  compatible_runtimes = ["python3.6"]
}

resource "aws_lambda_function" "TransitGatewayRouteMonitorLambda" {
  filename      = "./lambda/lambda-combined.zip"
  function_name = "TransitGatewayRouteMonitorLambda"
  role          = "${aws_iam_role.lambda_role.arn}"
  handler       = "TransitGatewayRouteMonitorLambda.lambda_handler"
  layers        = ["${aws_lambda_layer_version.external-modules-lambda.arn}"]


  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("./lambda/lambda-combined.zip")}"

  vpc_config {
    subnet_ids = ["${aws_subnet.vpc_security_lambda_1.id}","${aws_subnet.vpc_security_lambda_2.id}"]
    security_group_ids = ["${aws_security_group.data_nsg.id}"]
  }
  runtime = "python3.6"
  timeout = 30

  environment {
    variables = {
      preempt = "${var.preempt}"
      VpcSummaryRoute = "${var.vpc_summary_route}"
      fw2Trusteni = "${module.ngfw2.trust_eni_id}"
      fw1Trusteni = "${module.ngfw1.trust_eni_id}"
      fromTGWRouteTableId =  "${aws_route_table.vpc_security_tgw.id}"
      fw1Trustip = "${var.fw_ip_subnet_private_1}"
      fw2Trustip = "${var.fw_ip_subnet_private_2}"
      apikey = "${var.apikey}"
      splitroutes = "${var.split_routes}"
      Region = "${var.aws_region}"
    }
  }
}

resource "aws_cloudwatch_event_rule" "every_minute" {
    name = "every-one-minute"
    description = "Fires every minute"
    schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "lambda_check_every_minute" {
    rule = "${aws_cloudwatch_event_rule.every_minute.name}"
    target_id = "TransitGatewayRouteMonitorLambda"
    arn = "${aws_lambda_function.TransitGatewayRouteMonitorLambda.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_TransitGatewayRouteMonitorLambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.TransitGatewayRouteMonitorLambda.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.every_minute.arn}"
}