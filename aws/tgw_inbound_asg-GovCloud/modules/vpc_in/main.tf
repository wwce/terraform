#-----------------------------------------------------------------------------------------------
# Create IGW & VPC
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.tag}-igw"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "${var.cidr_vpc}"

  tags = {
    Name = "${var.tag}-vpc"
  }
}

#-----------------------------------------------------------------------------------------------
# Create mgmt subnets & mgmt route table
resource "aws_eip" "natgw" {
  count = "${length(var.cidr_natgw)}"
  vpc   = true
}


resource "aws_nat_gateway" "natgw" {
  count         = "${length(var.cidr_natgw)}"
  allocation_id = "${element(aws_eip.natgw.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.natgw.*.id, count.index)}"

  tags = {
    Name = "${var.tag}-natgw"
  }
}

resource "aws_route_table" "natgw" {
  count  = "${length(var.cidr_natgw)}"
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags = {
    Name = "${var.tag}-natgw-rt"
  }
}

resource "aws_subnet" "natgw" {
  count             = "${length(var.cidr_natgw)}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${element(var.cidr_natgw, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "${var.tag}-natgw"
  }
}

resource "aws_route_table_association" "natgw" {
  count          = "${length(var.cidr_natgw)}"
  subnet_id      = "${element(aws_subnet.natgw.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.natgw.*.id, count.index)}"
}

#-----------------------------------------------------------------------------------------------
# Create mgmt subnets & mgmt route table

resource "aws_subnet" "mgmt" {
  count             = "${length(var.cidr_mgmt)}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${element(var.cidr_mgmt, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "${var.tag}-mgmt"
  }

  depends_on = [
    "aws_nat_gateway.natgw",
    "aws_route_table.natgw",
    "aws_subnet.natgw",
    "aws_route_table_association.natgw",
  ]
}

resource "aws_route_table" "mgmt_natgw" {
  count  = "${length(var.cidr_mgmt)}"
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.natgw.*.id, count.index)}"
  }

  tags = {
    Name = "${var.tag}-mgmt-rt"
  }

  depends_on = [
    "aws_nat_gateway.natgw",
    "aws_route_table.natgw",
    "aws_subnet.natgw",
    "aws_route_table_association.natgw",
    "aws_internet_gateway.main",
    "aws_ec2_transit_gateway_vpc_attachment.main",
  ]
}

resource "aws_route_table_association" "mgmt_natgw" {
  count          = "${length(var.cidr_mgmt)}"
  subnet_id      = "${element(aws_subnet.mgmt.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.mgmt_natgw.*.id, count.index)}"

  depends_on = [
    "aws_nat_gateway.natgw",
    "aws_route_table.natgw",
    "aws_subnet.natgw",
    "aws_route_table_association.natgw",
    "aws_internet_gateway.main",
  ]
}

#-----------------------------------------------------------------------------------------------
# Create untrust subnets & untrust route table
resource "aws_subnet" "untrust" {
  count             = "${length(var.cidr_untrust)}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${element(var.cidr_untrust, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "${var.tag}-untrust"
  }

  depends_on = [
    "aws_ec2_transit_gateway_vpc_attachment.main",
    "aws_route_table_association.mgmt_natgw",
  ]
}

resource "aws_route_table" "untrust" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags = {
    Name = "${var.tag}-untrust-rt"
  }

  depends_on = [
    "aws_route_table_association.mgmt_natgw",
  ]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = "${aws_vpc.main.id}"
  service_name    = "com.amazonaws.${var.region}.s3"
  route_table_ids = ["${aws_route_table.untrust.id}"]
}

resource "aws_route_table_association" "untrust" {
  count          = "${length(var.cidr_untrust)}"
  subnet_id      = "${element(aws_subnet.untrust.*.id, count.index)}"
  route_table_id = "${aws_route_table.untrust.id}"

  depends_on = [
    "aws_route_table_association.mgmt_natgw",
  ]
}

#-----------------------------------------------------------------------------------------------
# Create trust subnets & trust route table
resource "aws_subnet" "trust" {
  count             = "${length(var.cidr_trust)}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${element(var.cidr_trust, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "${var.tag}-trust"
  }

  depends_on = [
    "aws_route_table_association.mgmt_natgw",
  ]
}

resource "aws_route_table" "trust" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = "${var.tgw_id}"
  }

  tags = {
    Name = "${var.tag}-trust-rt"
  }

  depends_on = [
    "aws_ec2_transit_gateway_vpc_attachment.main",
  ]
}

resource "aws_route_table_association" "trust" {
  count          = "${length(var.cidr_trust)}"
  subnet_id      = "${element(aws_subnet.trust.*.id, count.index)}"
  route_table_id = "${aws_route_table.trust.id}"
}

#-----------------------------------------------------------------------------------------------
# Create tgw attachment subnets & tgw  route table
resource "aws_subnet" "tgw" {
  count             = "${length(var.cidr_tgw)}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${element(var.cidr_tgw, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "${var.tag}-tgw"
  }
}

resource "aws_route_table" "tgw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.tag}-tgw-rt"
  }
}

resource "aws_route_table_association" "tgw" {
  count          = "${length(var.cidr_tgw)}"
  subnet_id      = "${element(aws_subnet.tgw.*.id, count.index)}"
  route_table_id = "${aws_route_table.tgw.id}"
}

#-----------------------------------------------------------------------------------------------
# Create lambda subnets & route table
resource "aws_subnet" "lambda" {
  count             = "${length(var.cidr_lambda)}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${element(var.cidr_lambda, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "${var.tag}-lambda"
  }
}

resource "aws_route_table" "lambda" {
  count  = "${length(var.cidr_lambda)}"
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.natgw.*.id, count.index)}"
  }

  tags = {
    Name = "${var.tag}-lambda-rt"
  }
}

resource "aws_route_table_association" "lambda" {
  count          = "${length(var.cidr_lambda)}"
  subnet_id      = "${element(aws_subnet.lambda.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.lambda.*.id, count.index)}"
}

#-----------------------------------------------------------------------------------------------
# Associate with TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  vpc_id = "${aws_vpc.main.id}"

  subnet_ids = ["${aws_subnet.tgw.*.id}"]

  transit_gateway_id                              = "${var.tgw_id}"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = "${var.tag}-attachment"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "main" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.main.id}"
  transit_gateway_route_table_id = "${var.tgw_rtb_id}"
}
