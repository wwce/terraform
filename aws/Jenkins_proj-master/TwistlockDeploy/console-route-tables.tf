resource "aws_internet_gateway" "consoleigw" {
  vpc_id = "${aws_vpc.console.id}"

  tags {
    Name = "internet gw console vpc"
  }
}

resource "aws_route_table" "public_console" {
  vpc_id = "${aws_vpc.console.id}"

  tags {
    Name = "PublicConsole"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.consoleigw.id}"
  }
}

resource "aws_route_table" "privateconsole" {
  vpc_id = "${aws_vpc.console.id}"
}

# Association

resource "aws_route_table_association" "consolesubnetroute1" {
  subnet_id      = "${aws_subnet.AZ1-console.id}"
  route_table_id = "${aws_route_table.public_console.id}"
}
