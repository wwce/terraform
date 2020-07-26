resource "aws_internet_gateway" "red_team_igw" {
  vpc_id = "${aws_vpc.red_team.id}"

  tags = {
    Name = "red_team"
  }
}