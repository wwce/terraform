resource "aws_eip" "blue_team_ngfw_untrust" {
  vpc   = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.blue_team_igw"]
  tags = {
    Name = "blue_team_ngfw_untrust"
  }
}

resource "aws_eip" "blue_team_ngfw_mgmt" {
  vpc   = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.blue_team_igw"]
  tags = {
    Name = "blue_team_ngfw_mgmt"
  }
}

resource "aws_eip" "blue_team_natgw" {
  vpc   = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.blue_team_igw"]
  tags = {
    Name = "blue_team_natgw"
  }
}
