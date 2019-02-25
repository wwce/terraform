module "spoke1" {
  source = "./vpc_spoke/"

  pemkey                  = "${var.aws_key}"
  serverip                = "${var.spoke1_server}"
  server2ip               = "${var.spoke1_server2}"
  servername              = "spoke1-server1"
  server2name             = "spoke1-server2"
  vpc_spoke_cidr          = "${var.spoke1_cidr}"
  vpc_spoke_subnet_cidr   = "${var.spoke1_subnet}"
  vpc_spoke_subnet2_cidr  = "${var.spoke1_subnet2}"
  aws_tgw_id              = "${aws_ec2_transit_gateway.tgw.id}"
  aws_tgw_spoke_rtb_id    = "${aws_ec2_transit_gateway_route_table.tgw_spokes.id}"
  aws_tgw_security_rtb_id = "${aws_ec2_transit_gateway_route_table.tgw_security.id}"
}

module "spoke2" {
  source = "./vpc_spoke/"

  pemkey                  = "${var.aws_key}"
  serverip                = "${var.spoke2_server}"
  server2ip               = "${var.spoke2_server2}"
  servername              = "spoke2-server"
  server2name             = "spoke2-server2"
  vpc_spoke_cidr          = "${var.spoke2_cidr}"
  vpc_spoke_subnet_cidr   = "${var.spoke2_subnet}"
  vpc_spoke_subnet2_cidr  = "${var.spoke2_subnet2}"
  aws_tgw_id              = "${aws_ec2_transit_gateway.tgw.id}"
  aws_tgw_spoke_rtb_id    = "${aws_ec2_transit_gateway_route_table.tgw_spokes.id}"
  aws_tgw_security_rtb_id = "${aws_ec2_transit_gateway_route_table.tgw_security.id}"
}
