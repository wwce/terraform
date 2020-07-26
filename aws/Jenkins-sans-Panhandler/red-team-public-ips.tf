resource "aws_eip" "red_team" {
  vpc        = true
  depends_on = ["aws_vpc.red_team", "aws_internet_gateway.red_team_igw"]
  tags = {
    Name = "red_team_server"
  }
}
