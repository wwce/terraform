# Route Tables
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.SDWAN.id}"

  tags {
    Name = "Public"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.SDWAN-IGW.id}"
  }
}
# Association

resource "aws_route_table_association" "mgt" {
  subnet_id      = "${aws_subnet.SD-WAN-MGT.id}"
  route_table_id = "${aws_route_table.public.id}"
}