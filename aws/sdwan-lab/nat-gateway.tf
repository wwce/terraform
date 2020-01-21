resource "aws_eip" "nat-gw" {
  vpc   = true
}

resource "aws_nat_gateway" "SDWAN-NGW" {
  allocation_id = "${aws_eip.nat-gw.id}"
  subnet_id     = "${aws_subnet.SD-WAN-MGT.id}"
  tags {
    Name = "SDWAN-NGW"
  }
}