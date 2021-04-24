# Route Tables
resource "aws_route_table" "blue_team_public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "blue_team_public"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.blue_team_igw.id
  }
}

resource "aws_route_table" "blue_team_private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "blue_team_private"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    network_interface_id = aws_network_interface.blue_team_ngfw_trust.id
  }
}

# Association

resource "aws_route_table_association" "blue_team_untrust" {
  subnet_id      = aws_subnet.blue_team_untrust.id
  route_table_id = aws_route_table.blue_team_public.id
}

resource "aws_route_table_association" "blue_team_mgmt" {
  subnet_id      = aws_subnet.blue_team_mgmt.id
  route_table_id = aws_route_table.blue_team_public.id
}

resource "aws_route_table_association" "blue_team_trust" {
  subnet_id      = aws_subnet.blue_team_trust.id
  route_table_id = aws_route_table.blue_team_private.id
}

