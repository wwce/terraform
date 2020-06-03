output "Transit Gateway ID" {
  value = "${aws_ec2_transit_gateway.tgw.id}"
}

output "TGW Route Table - Security" {
  value = "${aws_ec2_transit_gateway_route_table.tgw_security.id}"
}

output "TGW Route Table - Spokes" {
  value = "${aws_ec2_transit_gateway_route_table.tgw_spokes.id}"
}