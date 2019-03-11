resource "aws_vpc" "kali" {
  cidr_block       = "${var.KALICIDR}"
  instance_tenancy = "default"

  tags {
    Name = "kali"
  }
}

# Subnets
resource "aws_subnet" "AZ1-attack1" {
  vpc_id            = "${aws_vpc.kali.id}"
  cidr_block        = "${var.attackcidr1}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}
