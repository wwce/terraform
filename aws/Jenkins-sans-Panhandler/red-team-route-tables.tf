resource "aws_route_table" "red_team_public" {
  vpc_id = "${aws_vpc.red_team.id}"

  tags = {
    Name = "red_team_public"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.red_team_igw.id}"
  }
}

# Association

resource "aws_route_table_association" "red_team_public" {
  subnet_id      = "${aws_subnet.red_team_az1.id}"
  route_table_id = "${aws_route_table.red_team_public.id}"
}
