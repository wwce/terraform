#************************************************************************************
# CREATE SPOKE1 VPC & SPOKE1 VMs
#************************************************************************************
module "spoke1" {
  source = "./modules/vm-spoke/"

  pemkey                  = "${var.aws_key}"
  serverip                = "${var.spoke1_server}"
  server2ip               = "${var.spoke1_server2}"
  servername              = "spoke1-vm1"
  server2name             = "spoke1-vm2"
  vpc_spoke_cidr          = "${var.spoke1_cidr}"
  vpc_spoke_subnet_cidr   = "${var.spoke1_subnet}"
  vpc_spoke_subnet2_cidr  = "${var.spoke1_subnet2}"
  aws_tgw_id              = "${aws_ec2_transit_gateway.tgw.id}"
  aws_tgw_spoke_rtb_id    = "${aws_ec2_transit_gateway_route_table.tgw_spokes.id}"
  aws_tgw_security_rtb_id = "${aws_ec2_transit_gateway_route_table.tgw_security.id}"
}


#************************************************************************************
# CREATE SPOKE2 VPC & SPOKE2 VMs
#************************************************************************************
module "spoke2" {
  source = "./modules/vm-spoke/"

  pemkey                  = "${var.aws_key}"
  serverip                = "${var.spoke2_server}"
  server2ip               = "${var.spoke2_server2}"
  servername              = "spoke2-vm1"
  server2name             = "spoke2-vm2"
  vpc_spoke_cidr          = "${var.spoke2_cidr}"
  vpc_spoke_subnet_cidr   = "${var.spoke2_subnet}"
  vpc_spoke_subnet2_cidr  = "${var.spoke2_subnet2}"
  aws_tgw_id              = "${aws_ec2_transit_gateway.tgw.id}"
  aws_tgw_spoke_rtb_id    = "${aws_ec2_transit_gateway_route_table.tgw_spokes.id}"
  aws_tgw_security_rtb_id = "${aws_ec2_transit_gateway_route_table.tgw_security.id}"
}
