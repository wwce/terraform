variable vpc_spoke_cidr {
  description = "CIDR Network Address for Spoke VPC"
}

variable vpc_spoke_subnet_cidr {
  description = "CIDR Network Address for Spoke Subnet"
}

variable vpc_spoke_subnet2_cidr {
  description = "CIDR Network Address for Spoke Subnet"
}

variable aws_tgw_id {
  description = "AWS Transit Gateway ID"
}

variable aws_tgw_security_rtb_id {
  description = "AWS Transit Gateway Route Table Id"
}

variable aws_tgw_spoke_rtb_id {
  description = "AWS Transit Gateway Route Table Id"
}

variable pemkey {
  description = "AWS pem KEY"
}

variable serverip {
  description = "Ubuntu Server IP"
}

variable server2ip {
  description = "Ubuntu Server2 IP"
}

variable servername {
  description = "Ubuntu Server name"
}

variable server2name {
  description = "Ubuntu Server2 name"
}

resource "aws_vpc" "vpc_spoke" {
  cidr_block = "${var.vpc_spoke_cidr}"

  tags {
    Name = "vpc_spoke_${var.vpc_spoke_cidr}"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "primary" {
  vpc_id            = "${aws_vpc.vpc_spoke.id}"
  cidr_block        = "${var.vpc_spoke_subnet_cidr}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "vpc_spokeA_${var.vpc_spoke_subnet_cidr}"
  }
}

resource "aws_subnet" "secondary" {
  vpc_id            = "${aws_vpc.vpc_spoke.id}"
  cidr_block        = "${var.vpc_spoke_subnet2_cidr}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "vpc_spokeB_${var.vpc_spoke_subnet2_cidr}"
  }
}

resource "aws_security_group" "server_sg" {
  name        = "server_sg"
  description = "Allow select inbound traffic"
  vpc_id      = "${aws_vpc.vpc_spoke.id}"
}

resource "aws_security_group_rule" "allow_server_sg_ingress" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["10.0.0.0/8", "192.168.0.0/16"]

  security_group_id = "${aws_security_group.server_sg.id}"
}

resource "aws_security_group_rule" "allow_server_sg_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.server_sg.id}"
}

resource "aws_route" "vpc_spoke_route_1" {
  route_table_id         = "${aws_vpc.vpc_spoke.default_route_table_id}"
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = "${var.aws_tgw_id}"
}

resource "aws_route" "vpc_spoke_route_2" {
  route_table_id         = "${aws_vpc.vpc_spoke.default_route_table_id}"
  destination_cidr_block = "192.168.0.0/16"
  transit_gateway_id     = "${var.aws_tgw_id}"
}

resource "aws_route" "vpc_spoke_route_3" {
  route_table_id         = "${aws_vpc.vpc_spoke.default_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = "${var.aws_tgw_id}"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_spoke_attachment" {
  vpc_id                                          = "${aws_vpc.vpc_spoke.id}"
  subnet_ids                                      = ["${aws_subnet.primary.id}", "${aws_subnet.secondary.id}"]
  transit_gateway_id                              = "${var.aws_tgw_id}"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags {
    Name = "tgw_attachment_spoke_${var.vpc_spoke_cidr}"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc_spoke_1" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_spoke_attachment.id}"
  transit_gateway_route_table_id = "${var.aws_tgw_spoke_rtb_id}"
}

resource "aws_ec2_transit_gateway_route_table_propagation" "route_table_propagation" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_spoke_attachment.id}"
  transit_gateway_route_table_id = "${var.aws_tgw_security_rtb_id}"
}

//Server in subnet
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
  key_name        = "${var.pemkey}"
  subnet_id       = "${aws_subnet.primary.id}"
  private_ip      = "${var.serverip}"
  security_groups = ["${aws_security_group.server_sg.id}"]

  tags = {
    Name = "${var.servername}"
  }
}

resource "aws_instance" "web2" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
  key_name        = "${var.pemkey}"
  subnet_id       = "${aws_subnet.secondary.id}"
  private_ip      = "${var.server2ip}"
  security_groups = ["${aws_security_group.server_sg.id}"]

  tags = {
    Name = "${var.server2name}"
  }
}

//End Server
output "vpc_id" {
  value = "${aws_vpc.vpc_spoke.id}"
}

output "subnet_id" {
  value = "${aws_subnet.primary.id}"
}
