provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

# Declare the data source
#data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block       = "${var.VPCCIDR}"
  instance_tenancy = "default"

  tags {
    Name = "main"
  }
}

# Subnets
resource "aws_subnet" "AZ1-TRUST" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.WebCIDR_TrustBlock1}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "AZ1-TRUST"
  }
}

resource "aws_subnet" "AZ1-UNTRUST" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.WebCIDR_UntrustBlock1}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "AZ1-UNTRUST"
  }
}

resource "aws_subnet" "AZ1-MGT" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.WebCIDR_MGMT1}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "AZ1-MGT"
  }
}

resource "aws_subnet" "AZ2-TRUST" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.WebCIDR_TrustBlock2}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "AZ2-TRUST"
  }
}

resource "aws_subnet" "AZ2-UNTRUST" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.WebCIDR_UntrustBlock2}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "AZ2-UNTRUST"
  }
}

resource "aws_subnet" "AZ2-MGT" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.WebCIDR_MGMT2}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "AZ2-MGT"
  }
}
