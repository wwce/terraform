data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc_security" {
  cidr_block = "${var.vpc_security_cidr}"

  tags {
    Name = "vpc_security"
  }
}

resource "aws_subnet" "vpc_security_public_1" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_security_subnet_public_1}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "vpc_security_public_1"
  }
}

resource "aws_subnet" "vpc_security_public_2" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_security_subnet_public_2}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "vpc_security_public_2"
  }
}

resource "aws_subnet" "vpc_security_private_1" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_security_subnet_private_1}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "vpc_security_private_1"
  }
}

resource "aws_subnet" "vpc_security_private_2" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_security_subnet_private_2}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "vpc_security_private_2"
  }
}

resource "aws_subnet" "vpc_security_tgw_1" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_security_subnet_tgw_1}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "vpc_security_tgw_1"
  }
}

resource "aws_subnet" "vpc_security_tgw_2" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_security_subnet_tgw_2}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "vpc_security_tgw_2"
  }
}

resource "aws_route_table" "vpc_security_tgw_1" {
  vpc_id = "${aws_vpc.vpc_security.id}"

  tags {
    Name = "tgw_1"
  }
}

resource "aws_route_table" "vpc_security_tgw_2" {
  vpc_id = "${aws_vpc.vpc_security.id}"

  tags {
    Name = "tgw_2"
  }
}

resource "aws_route_table" "vpc_security_private_1" {
  vpc_id = "${aws_vpc.vpc_security.id}"

  tags {
    Name = "private_1"
  }
}

resource "aws_route_table" "vpc_security_private_2" {
  vpc_id = "${aws_vpc.vpc_security.id}"

  tags {
    Name = "private_2"
  }
}

resource "aws_route_table_association" "vpc_security_private_1" {
  subnet_id      = "${aws_subnet.vpc_security_private_1.id}"
  route_table_id = "${aws_route_table.vpc_security_private_1.id}"
}

resource "aws_route_table_association" "vpc_security_private_2" {
  subnet_id      = "${aws_subnet.vpc_security_private_2.id}"
  route_table_id = "${aws_route_table.vpc_security_private_2.id}"
}

resource "aws_route_table_association" "vpc_security_tgw_1" {
  subnet_id      = "${aws_subnet.vpc_security_tgw_1.id}"
  route_table_id = "${aws_route_table.vpc_security_tgw_1.id}"
}

resource "aws_route_table_association" "vpc_security_tgw_2" {
  subnet_id      = "${aws_subnet.vpc_security_tgw_2.id}"
  route_table_id = "${aws_route_table.vpc_security_tgw_2.id}"
}

resource "aws_route" "vpc_security_tgw_1_0" {
  route_table_id         = "${aws_route_table.vpc_security_tgw_1.id}"
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = "${module.ngfw1.eni-trust}"
}

resource "aws_route" "vpc_security_tgw_1_1" {
  route_table_id         = "${aws_route_table.vpc_security_tgw_1.id}"
  destination_cidr_block = "10.0.0.0/8"
  network_interface_id   = "${module.ngfw1.eni-trust}"
}

resource "aws_route" "vpc_security_tgw_2_0" {
  route_table_id         = "${aws_route_table.vpc_security_tgw_2.id}"
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = "${module.ngfw2.eni-trust}"
}

resource "aws_route" "vpc_security_tgw_2_1" {
  route_table_id         = "${aws_route_table.vpc_security_tgw_2.id}"
  destination_cidr_block = "10.0.0.0/8"
  network_interface_id   = "${module.ngfw2.eni-trust}"
}

resource "aws_route" "vpc_security_trust_1_0" {
  route_table_id         = "${aws_route_table.vpc_security_private_1.id}"
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = "${aws_ec2_transit_gateway.tgw.id}"
}

resource "aws_route" "vpc_security_trust_2_0" {
  route_table_id         = "${aws_route_table.vpc_security_private_2.id}"
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = "${aws_ec2_transit_gateway.tgw.id}"
}

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

module "ngfw1" {
  source = "./vm-series/"

  name = "ngfw1"

  aws_key = "${var.aws_key}"

  trust_subnet_id         = "${aws_subnet.vpc_security_private_1.id}"
  trust_security_group_id = "${aws_security_group.allow_all.id}"
  trustfwip               = "${var.fw_ip_subnet_private_1}"

  untrust_subnet_id         = "${aws_subnet.vpc_security_public_1.id}"
  untrust_security_group_id = "${aws_security_group.allow_all.id}"
  untrustfwip               = "${var.fw_ip_subnet_public_1 }"

  management_subnet_id         = "${aws_subnet.vpc_security_public_1.id}"
  management_security_group_id = "${aws_security_group.allow_https_ssh.id}"

  bootstrap_profile  = "${aws_iam_instance_profile.bootstrap_profile.id}"
  bootstrap_s3bucket = "${var.bootstrap_s3bucket}"

  tgw_id = "${aws_ec2_transit_gateway.tgw.id}"

  aws_region = "${var.aws_region}"
}

module "ngfw2" {
  source = "./vm-series/"

  name = "ngfw2"

  aws_key = "${var.aws_key}"

  trust_subnet_id         = "${aws_subnet.vpc_security_private_2.id}"
  trust_security_group_id = "${aws_security_group.allow_all.id}"
  trustfwip               = "${var.fw_ip_subnet_private_2}"

  untrust_subnet_id         = "${aws_subnet.vpc_security_public_2.id}"
  untrust_security_group_id = "${aws_security_group.allow_all.id}"
  untrustfwip               = "${var.fw_ip_subnet_public_2 }"

  management_subnet_id         = "${aws_subnet.vpc_security_public_2.id}"
  management_security_group_id = "${aws_security_group.allow_https_ssh.id}"

  bootstrap_profile  = "${aws_iam_instance_profile.bootstrap_profile2.id}"
  bootstrap_s3bucket = "${var.bootstrap_s3bucket2}"

  tgw_id = "${aws_ec2_transit_gateway.tgw.id}"

  aws_region = "${var.aws_region}"
}

output "FW-1-MGMT" {
  value = "Access the firewall MGMT via:  https://${module.ngfw1.eip_mgmt}"
}

output "Server-1-1_ngfw1_access" {
  value = "Access Server 1-1 via FW-1: ssh -i <Insert Key> ubuntu@${module.ngfw1.eip_untrust} -p 1001"
}

output "Server-1-2_ngfw1_access" {
  value = "Access Server 1-2 via FW-1: ssh -i <Insert Key> ubuntu@${module.ngfw1.eip_untrust} -p 1002"
}

output "Server-2-1_ngfw1_access" {
  value = "Access Server 2-1 via FW-1: ssh -i <Insert Key> ubuntu@${module.ngfw1.eip_untrust} -p 2001"
}

output "Server-2-2_ngfw1_access" {
  value = "Access Server 2-2 via FW-1: ssh -i <Insert Key> ubuntu@${module.ngfw1.eip_untrust} -p 2002"
}

output "FW-2-MGMT" {
  value = "Access the firewall MGMT via:  https://${module.ngfw2.eip_mgmt}"
}

output "Server-1-1_ngfw2_access" {
  value = "Access Server 1-1 via FW-2: ssh -i <Insert Key> ubuntu@${module.ngfw2.eip_untrust} -p 1001"
}

output "Server-1-2_ngfw2_access" {
  value = "Access Server 1-2 via FW-2: ssh -i <Insert Key> ubuntu@${module.ngfw2.eip_untrust} -p 1002"
}

output "Server-2-1_ngfw2_access" {
  value = "Access Server 2-1 via FW-2: ssh -i <Insert Key> ubuntu@${module.ngfw2.eip_untrust} -p 2001"
}

output "Server-2-2_ngfw2_access" {
  value = "Access Server 2-2 via FW-2: ssh -i <Insert Key> ubuntu@${module.ngfw2.eip_untrust} -p 2002"
}
