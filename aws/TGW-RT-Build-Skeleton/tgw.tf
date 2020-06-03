resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "Transit Gateway"
  vpn_ecmp_support                = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  auto_accept_shared_attachments  = "disable"

  tags = {
    Name = "transit_gateway"
  }
}

resource "aws_ec2_transit_gateway_route_table" "tgw_security" {
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw.id}"

  tags = {
    Name = "security-tgw-rtb"
  }
}

resource "aws_ec2_transit_gateway_route_table" "tgw_spokes" {
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw.id}"

  tags = {
    Name = "spokes-tgw-rtb"
    Propagation = "NS"
  }
}
