provider "aws" {
  region     = "${var.aws_region}"
  #access_key = "${var.aws_access_key}"
  #secret_key = "${var.aws_secret_key}"
}

# Declare the data sources
data "aws_availability_zones" "available" {}

resource "random_id" "sdwan" {
  byte_length = 3
}
resource "aws_vpc" "SDWAN" {
  cidr_block       = "${var.VPCCIDR}"
  instance_tenancy = "default"

  tags {
    Name = "SDWAN"
  }
}

# Subnets
resource "aws_subnet" "SD-WAN-MGT" {
  vpc_id            = "${aws_vpc.SDWAN.id}"
  cidr_block        = "${var.SD-WAN-MGT}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "SD-WAN-MGT"
  }
}

resource "aws_subnet" "SD-WAN-WAN1" {
  vpc_id            = "${aws_vpc.SDWAN.id}"
  cidr_block        = "${var.SD-WAN-WAN1}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "SD-WAN-WAN1"
  }
}

resource "aws_subnet" "SD-WAN-WAN2" {
  vpc_id            = "${aws_vpc.SDWAN.id}"
  cidr_block        = "${var.SD-WAN-WAN2}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "SD-WAN-WAN2"
  }
}

resource "aws_subnet" "SD-WAN-WAN3" {
  vpc_id            = "${aws_vpc.SDWAN.id}"
  cidr_block        = "${var.SD-WAN-WAN3}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "SD-WAN-WAN3"
  }
}

resource "aws_subnet" "SD-WAN-WAN4" {
  vpc_id            = "${aws_vpc.SDWAN.id}"
  cidr_block        = "${var.SD-WAN-WAN4}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "SD-WAN-WAN4"
  }
}

resource "aws_subnet" "SD-WAN-MPLS" {
  vpc_id            = "${aws_vpc.SDWAN.id}"
  cidr_block        = "${var.SD-WAN-MPLS}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "SD-WAN-MPLS"
  }
}

resource "aws_subnet" "SD-WAN-Branch25" {
  vpc_id            = "${aws_vpc.SDWAN.id}"
  cidr_block        = "${var.SD-WAN-Branch25}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "SD-WAN-Branch25"
  }
}

resource "aws_subnet" "SD-WAN-Branch50" {
  vpc_id            = "${aws_vpc.SDWAN.id}"
  cidr_block        = "${var.SD-WAN-Branch50}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "SD-WAN-Branch50"
  }
}

resource "aws_subnet" "SD-WAN-Hub" {
  vpc_id            = "${aws_vpc.SDWAN.id}"
  cidr_block        = "${var.SD-WAN-Hub}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "SD-WAN-Hub"
  }
}

