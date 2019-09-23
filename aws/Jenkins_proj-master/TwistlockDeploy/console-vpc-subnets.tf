resource "aws_vpc" "console" {
  cidr_block       = "${var.CONSOLECIDR}"
  instance_tenancy = "default"

  tags {
    Name = "console"
  }
}

# Subnets
resource "aws_subnet" "AZ1-console" {
  vpc_id            = "${aws_vpc.console.id}"
  cidr_block        = "${var.CONSOLECIDR}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}
