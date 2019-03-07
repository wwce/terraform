resource "aws_internet_gateway" "kaligw" {
  vpc_id = "${aws_vpc.kali.id}"

  tags {
    Name = "internet gw kali vpc"
  }
}

resource "aws_route_table" "publickali" {
  vpc_id = "${aws_vpc.kali.id}"

  tags {
    Name = "PublicKali"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.kaligw.id}"
  }
}

resource "aws_route_table" "privatekali" {
  vpc_id = "${aws_vpc.kali.id}"
}

# Association

resource "aws_route_table_association" "kalisubnetroute1" {
  subnet_id      = "${aws_subnet.AZ1-attack1.id}"
  route_table_id = "${aws_route_table.publickali.id}"
}
