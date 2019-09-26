data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc_security" {
  cidr_block = "${var.vpc_security_cidr}"

  tags {
    Name = "vpc_security"
  }
}


#################
#  Mirror Subnets
#################
resource "aws_subnet" "vpc_mirror_pub_1" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_mirror_pub_1}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "vpc_mirror_pub_1"
  }
}


resource "aws_subnet" "vpc_mirror_pub_2" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_mirror_pub_2}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "vpc_mirror_pub_2"
  }
}


###################




resource "aws_internet_gateway" "vpc_security_igw" {
  vpc_id = "${aws_vpc.vpc_security.id}"

  tags {
    Name = "vpc_securty_igw"
  }
}

resource "aws_route" "vpc_security_default" {
  route_table_id         = "${aws_vpc.vpc_security.default_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.vpc_security_igw.id}"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.vpc_security.id}"
}

resource "aws_security_group_rule" "allow_all_ingress" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.allow_all.id}"
}

resource "aws_security_group_rule" "allow_all_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.allow_all.id}"
}

resource "aws_security_group" "allow_https_ssh" {
  name        = "allow_https_ssh"
  description = "Allow HTTPS and SSH inbound traffic"
  vpc_id      = "${aws_vpc.vpc_security.id}"
}

resource "aws_security_group_rule" "allow_ssh_ingress" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["${var.management_cidr}"]

  security_group_id = "${aws_security_group.allow_https_ssh.id}"
}

resource "aws_security_group_rule" "allow_https_ingress" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["${var.management_cidr}"]

  security_group_id = "${aws_security_group.allow_https_ssh.id}"
}

resource "aws_security_group_rule" "allow_all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.allow_https_ssh.id}"
}

###################
# VPC Mirror FWs
###################
module "ngfw3" {
  source = "./vm-series/"

  name = "ngfw3"

  aws_key = "${var.aws_key}"

  

  untrust_subnet_id         = "${aws_subnet.vpc_mirror_pub_1.id}"
  untrust_security_group_id = "${aws_security_group.allow_all.id}"
  untrustfwip               = "${var.fw_ip_subnet_pub_1}"

  management_subnet_id         = "${aws_subnet.vpc_mirror_pub_1.id}"
  management_security_group_id = "${aws_security_group.allow_https_ssh.id}"
  mgmtfwip                     = "${var.fw_ip_subnet_mgmt_1}"

  bootstrap_profile  = "${aws_iam_instance_profile.bootstrap_profile3.id}"
  bootstrap_s3bucket = "${var.bootstrap_s3bucket3}"

  

  aws_region = "${var.aws_region}"
}
module "ngfw4" {
  source = "./vm-series/"

  name = "ngfw4"

  aws_key = "${var.aws_key}"

  

  untrust_subnet_id         = "${aws_subnet.vpc_mirror_pub_2.id}"
  untrust_security_group_id = "${aws_security_group.allow_all.id}"
  untrustfwip               = "${var.fw_ip_subnet_pub_2}"
  
  management_subnet_id         = "${aws_subnet.vpc_mirror_pub_2.id}"
  management_security_group_id = "${aws_security_group.allow_https_ssh.id}"
  mgmtfwip                     = "${var.fw_ip_subnet_mgmt_2}"

  bootstrap_profile  = "${aws_iam_instance_profile.bootstrap_profile4.id}"
  bootstrap_s3bucket = "${var.bootstrap_s3bucket4}"

  

  aws_region = "${var.aws_region}"
}
#######################

output "FW-3-MGMT" {
  value = "Access the firewall MGMT via:  https://${module.ngfw3.eip_mgmt}"
}
output "FW-4-MGMT" {
  value = "Access the firewall MGMT via:  https://${module.ngfw4.eip_mgmt}"
}
