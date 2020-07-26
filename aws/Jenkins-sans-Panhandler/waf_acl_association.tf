resource "aws_wafv2_web_acl_association" "ngfw-alb" {
  resource_arn = "${aws_lb.ngfw-alb.arn}"
  web_acl_arn  = "${aws_wafv2_web_acl.waf_acl.arn}"
}
resource "aws_wafv2_web_acl_association" "native-alb" {
  resource_arn = "${aws_lb.native-alb.arn}"
  web_acl_arn  = "${aws_wafv2_web_acl.waf_acl.arn}"
}
