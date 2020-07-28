# Route Tables
resource "aws_route_table" "blue_team_public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "blue_team_public"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.blue_team_igw.id}"
  }
}

resource "aws_route_table" "blue_team_private" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "blue_team_private"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.blue_team_natgw.id}"
  }
}

# Association

resource "aws_route_table_association" "blue_team_az1_untrust" {
  subnet_id      = "${aws_subnet.blue_team_az1_untrust.id}"
  route_table_id = "${aws_route_table.blue_team_public.id}"
}

resource "aws_route_table_association" "blue_team_az1_mgmt" {
  subnet_id      = "${aws_subnet.blue_team_az1_mgmt.id}"
  route_table_id = "${aws_route_table.blue_team_public.id}"
}

resource "aws_route_table_association" "blue_team_az2_untrust" {
  subnet_id      = "${aws_subnet.blue_team_az2_untrust.id}"
  route_table_id = "${aws_route_table.blue_team_public.id}"
}

resource "aws_route_table_association" "blue_team_az2_mgmt" {
  subnet_id      = "${aws_subnet.blue_team_az2_mgmt.id}"
  route_table_id = "${aws_route_table.blue_team_public.id}"
}

resource "aws_route_table_association" "blue_team_az1_trust" {
  subnet_id      = "${aws_subnet.blue_team_az1_trust.id}"
  route_table_id = "${aws_route_table.blue_team_private.id}"
}

resource "aws_route_table_association" "blue_team_az2_trust" {
  subnet_id      = "${aws_subnet.blue_team_az2_trust.id}"
  route_table_id = "${aws_route_table.blue_team_private.id}"
}
