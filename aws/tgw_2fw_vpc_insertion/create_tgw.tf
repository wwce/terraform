#************************************************************************************
# CREATE TGW
#************************************************************************************
resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "Transit Gateway"
  vpn_ecmp_support                = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  auto_accept_shared_attachments  = "disable"

  tags {
    Name = "tgw"
  }
}

#************************************************************************************
# CREATE TGW ROUTE TABLES
#************************************************************************************
resource "aws_ec2_transit_gateway_route_table" "tgw_security" {
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw.id}"

  tags {
    Name = "tgw-rtb-security"
  }
}

resource "aws_ec2_transit_gateway_route_table" "tgw_spokes" {
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw.id}"

  tags {
    Name = "tgw-rtb-spokes"
  }
}

#************************************************************************************
# CREATE ROUTES FOR TGW ROUTE TABLES
#************************************************************************************
resource "aws_ec2_transit_gateway_route" "default" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_security.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw_spokes.id}"
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc_security" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_security.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw_security.id}"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_security" {
  vpc_id                                          = "${aws_vpc.vpc_security.id}"
  subnet_ids                                      = ["${aws_subnet.vpc_security_tgw_1.id}", "${aws_subnet.vpc_security_tgw_2.id}"]
  transit_gateway_id                              = "${aws_ec2_transit_gateway.tgw.id}"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags {
    Name = "fw-vpc-attachment"
  }
}
