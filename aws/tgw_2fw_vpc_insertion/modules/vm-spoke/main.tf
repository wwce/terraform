variable vpc_spoke_cidr {}
variable vpc_spoke_subnet_cidr {}
variable vpc_spoke_subnet2_cidr {}
variable aws_tgw_id {}
variable aws_tgw_security_rtb_id {}
variable aws_tgw_spoke_rtb_id {}
variable pemkey {}
variable serverip {}
variable server2ip {}
variable servername {}
variable server2name {}


#************************************************************************************
# CREATE SPOKE-VPC
#************************************************************************************
resource "aws_vpc" "vpc_spoke" {
  cidr_block = "${var.vpc_spoke_cidr}"

  tags {
    Name = "vpc_spoke_${var.vpc_spoke_cidr}"
  }
}


#************************************************************************************
# CREATE SPOKE-VPC SUBNETS
#************************************************************************************
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


#************************************************************************************
# CREATE SPOKE-VPC SUBNET ROUTE TABLE
#************************************************************************************
resource "aws_route" "vpc_spoke_route_1" {
  route_table_id         = "${aws_vpc.vpc_spoke.default_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = "${var.aws_tgw_id}"
}


#************************************************************************************
# CREATE NSGs & NSG RULES FOR SPOKE-VM ENIs
#************************************************************************************
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
  cidr_blocks = ["0.0.0.0/0"]

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


#************************************************************************************
# CREATE TGW ATTACHMENT FOR SPOKE-VPC
#************************************************************************************
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


#************************************************************************************
# ASSOCIATE TGW ROUTE TABLE W/ SPOKE ATTACHMENT (route table created in create_tgw.tf)
#************************************************************************************
resource "aws_ec2_transit_gateway_route_table_association" "vpc_spoke_1" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_spoke_attachment.id}"
  transit_gateway_route_table_id = "${var.aws_tgw_spoke_rtb_id}"
}

resource "aws_ec2_transit_gateway_route_table_propagation" "route_table_propagation" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_spoke_attachment.id}"
  transit_gateway_route_table_id = "${var.aws_tgw_security_rtb_id}"
}


#************************************************************************************
# CREATE SPOKE VMs
#************************************************************************************
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


#************************************************************************************
# OUTPUT SPOKE-VPC IDs
#************************************************************************************
output "vpc_id" {
  value = "${aws_vpc.vpc_spoke.id}"
}

output "subnet_id" {
  value = "${aws_subnet.primary.id}"
}
