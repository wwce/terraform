# Route Tables
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "Public"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "Private"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
  }
}

# Association

resource "aws_route_table_association" "subnetroute1" {
  subnet_id      = "${aws_subnet.AZ1-UNTRUST.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "subnetroute2" {
  subnet_id      = "${aws_subnet.AZ1-MGT.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "subnetroute3" {
  subnet_id      = "${aws_subnet.AZ2-UNTRUST.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "subnetroute4" {
  subnet_id      = "${aws_subnet.AZ2-MGT.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "subnetroute5" {
  subnet_id      = "${aws_subnet.AZ1-TRUST.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "subnetroute6" {
  subnet_id      = "${aws_subnet.AZ2-TRUST.id}"
  route_table_id = "${aws_route_table.private.id}"
}
