resource "aws_internet_gateway" "blue_team_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "blue_team"
  }
}

