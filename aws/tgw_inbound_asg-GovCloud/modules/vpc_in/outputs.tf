output "mgmt_id" {
  value = "${aws_subnet.mgmt.*.id}"
}

output "untrust_id" {
  value = "${aws_subnet.untrust.*.id}"
}

output "trust_id" {
  value = "${aws_subnet.trust.*.id}"
}

output "tgw_id" {
  value = "${aws_subnet.tgw.*.id}"
}

output "lambda_id" {
  value = "${aws_subnet.lambda.*.id}"
}

output "natgw_id" {
  value = "${aws_subnet.natgw.*.id}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "tgw_vpc_attachment_id" {
  value = "${aws_ec2_transit_gateway_vpc_attachment.main.id}"
}

output "default_security_group_id" {
  value = "${aws_vpc.main.default_security_group_id}"
}

output "untrust_route_table_id" {
  value = "${aws_route_table.untrust.id}"
}
