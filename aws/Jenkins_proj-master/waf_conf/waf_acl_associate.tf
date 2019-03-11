provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}
data "aws_alb" "panos-alb" {
  name = "panos-alb"
}
data "aws_alb" "native-alb" {
  name = "native-alb"
}

resource "aws_wafregional_web_acl_association" "ext-alb" {
  resource_arn = "${data.aws_alb.panos-alb.arn}"
  web_acl_id   = "${aws_wafregional_web_acl.wafregional_acl.id}"
}
resource "aws_wafregional_web_acl_association" "native-alb" {
  resource_arn = "${data.aws_alb.native-alb.arn}"
  web_acl_id   = "${aws_wafregional_web_acl.wafregional_acl.id}"
}
