resource "aws_vpc" "main" {
  cidr_block       = "${var.blue_team_cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "blue_team"
  }
}

# Subnets
resource "aws_subnet" "blue_team_az1_trust" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.blue_team_az1_trust}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "blue_team_az1_trust"
  }
}

resource "aws_subnet" "blue_team_az1_untrust" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.blue_team_az1_untrust}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "blue_team_az1_untrust"
  }
}

resource "aws_subnet" "blue_team_az1_mgmt" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.blue_team_az1_mgmt}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "blue_team_az1_mgmt"
  }
}

resource "aws_subnet" "blue_team_az2_trust" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.blue_team_az2_trust}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "blue_team_az2_trust"
  }
}

resource "aws_subnet" "blue_team_az2_untrust" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.blue_team_az2_untrust}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "blue_team_az2_untrust"
  }
}

resource "aws_subnet" "blue_team_az2_mgmt" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.blue_team_az2_mgmt}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "blue_team_az2_mgmt"
  }
}
