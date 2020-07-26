resource "aws_vpc" "red_team" {
  cidr_block       = "${var.red_team_cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "red_team"
  }
}

# Subnets
resource "aws_subnet" "red_team_az1" {
  vpc_id            = "${aws_vpc.red_team.id}"
  cidr_block        = "${var.red_team_cidr}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "red_team_az1"
  }
}
