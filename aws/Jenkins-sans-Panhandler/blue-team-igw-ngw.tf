resource "aws_nat_gateway" "blue_team_natgw" {
  allocation_id = "${aws_eip.blue_team_natgw.id}"
  subnet_id     = "${aws_subnet.blue_team_az1_untrust.id}"
  depends_on    = ["aws_internet_gateway.blue_team_igw"]

  tags = {
    Name = "blue_team"
  }
}

resource "aws_internet_gateway" "blue_team_igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "blue_team"
  }
}