resource "aws_vpc" "main" {
  cidr_block       = var.blue_team_cidr
  instance_tenancy = "default"

  tags = {
    Name = "blue_team"
  }
}

# Subnets
resource "aws_subnet" "blue_team_trust" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.blue_team_trust
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "blue_team_trust"
  }
}

resource "aws_subnet" "blue_team_untrust" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.blue_team_untrust
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "blue_team_untrust"
  }
}

resource "aws_subnet" "blue_team_mgmt" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.blue_team_mgmt
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "blue_team_mgmt"
  }
}

