resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.NAT_GW.id}"
  subnet_id     = "${aws_subnet.AZ1-UNTRUST.id}"
  depends_on    = ["aws_internet_gateway.gw"]

  tags = {
    Name = "gw NAT"
  }
}
