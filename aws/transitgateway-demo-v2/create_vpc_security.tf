data "aws_availability_zones" "available" {}



#************************************************************************************
# CREATE SECURITY VPC & SUBNETS
#************************************************************************************
resource "aws_vpc" "vpc_security" {
  cidr_block = "${var.vpc_security_cidr}"

  tags {
    Name = "fw-vpc"
  }
}

resource "aws_subnet" "vpc_security_mgmt_1" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_security_subnet_mgmt_1}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "mgmt-fw1"
  }
}

resource "aws_subnet" "vpc_security_mgmt_2" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_security_subnet_mgmt_2}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "mgmt-fw2"
  }
}

resource "aws_subnet" "vpc_security_untrust1" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_security_subnet_public_1}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "untrust-fw1"
  }
}

resource "aws_subnet" "vpc_security_untrust2" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_security_subnet_public_2}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "untrust-fw2"
  }
}

resource "aws_subnet" "vpc_security_trust_1" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_security_subnet_private_1}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "trust-fw1"
  }
}

resource "aws_subnet" "vpc_security_trust_2" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_security_subnet_private_2}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "trust-fw2"
  }
}

resource "aws_subnet" "vpc_security_tgw_1" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_security_subnet_tgw_1}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "tgw-fw1"
  }
}

resource "aws_subnet" "vpc_security_tgw_2" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_security_subnet_tgw_2}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "tgw-fw2"
  }
}

resource "aws_subnet" "vpc_security_lambda_1" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_security_subnet_lambda_1}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "lambda-subnet1"
  }
}

resource "aws_subnet" "vpc_security_lambda_2" {
  vpc_id            = "${aws_vpc.vpc_security.id}"
  cidr_block        = "${var.vpc_security_subnet_lambda_2}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "lambda-subnet2"
  }
}

#************************************************************************************
# CREATE IGW FOR SECURITY VPC
#************************************************************************************
resource "aws_internet_gateway" "vpc_security_igw" {
  vpc_id = "${aws_vpc.vpc_security.id}"

  tags {
    Name = "igw-security-vpc"
  }
}

#************************************************************************************
# CREATE ROUTE TABLES FOR SUBNETS
#************************************************************************************
resource "aws_route_table" "vpc_security_mgmt" {
  vpc_id = "${aws_vpc.vpc_security.id}"

  tags {
    Name = "fw-mgmt"
  }
}

resource "aws_route_table" "vpc_security_untrust" {
  vpc_id = "${aws_vpc.vpc_security.id}"

  tags {
    Name = "fw-untrust"
  }
}

resource "aws_route_table" "vpc_security_trust" {
  vpc_id = "${aws_vpc.vpc_security.id}"

  tags {
    Name = "fw-to-tgw"
  }
}

resource "aws_route_table" "vpc_security_tgw" {
  vpc_id = "${aws_vpc.vpc_security.id}"

  tags {
    Name = "fw-from-tgw"
  }
}
resource "aws_route_table" "vpc_security_lambda_1" {
  vpc_id = "${aws_vpc.vpc_security.id}"

  tags {
    Name = "lambda-r1-1"
  }
}
resource "aws_route_table" "vpc_security_lambda_2" {
  vpc_id = "${aws_vpc.vpc_security.id}"

  tags {
    Name = "lambda-rt-2"
  }
}



#************************************************************************************
# CREATE ROUTES FOR SUBNET ROUTE TABLES
#************************************************************************************
resource "aws_route" "vpc_security_mgmt" {
  route_table_id         = "${aws_route_table.vpc_security_mgmt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.vpc_security_igw.id}"
}

resource "aws_route" "vpc_security_untrust" {
  route_table_id         = "${aws_route_table.vpc_security_untrust.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.vpc_security_igw.id}"
}
resource "aws_route" "vpc_security_lambda_1" {
  route_table_id         = "${aws_route_table.vpc_security_lambda_1.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_nat_gateway.natgw1.id}"
}
resource "aws_route" "vpc_security_lambda_2" {
  route_table_id         = "${aws_route_table.vpc_security_lambda_2.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_nat_gateway.natgw2.id}"
}

resource "aws_route" "vpc_security_trust" {
  route_table_id         = "${aws_route_table.vpc_security_trust.id}"
  destination_cidr_block = "${var.all_spoke_cidr}"
  transit_gateway_id     = "${aws_ec2_transit_gateway.tgw.id}"
}

resource "aws_route" "vpc_security_tgw_0" {
  route_table_id         = "${aws_route_table.vpc_security_tgw.id}"
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = "${module.ngfw1.eni-trust}"
}

resource "aws_route" "vpc_security_tgw_1" {
  route_table_id         = "${aws_route_table.vpc_security_tgw.id}"
  destination_cidr_block = "${var.all_spoke_cidr}"
  network_interface_id   = "${module.ngfw2.eni-trust}"
}

#************************************************************************************
# ASSOCIATE ROUTE TABLES WITH SUBNETS 
#************************************************************************************
resource "aws_route_table_association" "vpc_security_mgmt_1" {
  subnet_id      = "${aws_subnet.vpc_security_mgmt_1.id}"
  route_table_id = "${aws_route_table.vpc_security_mgmt.id}"
}

resource "aws_route_table_association" "vpc_security_mgmt_2" {
  subnet_id      = "${aws_subnet.vpc_security_mgmt_2.id}"
  route_table_id = "${aws_route_table.vpc_security_mgmt.id}"
}

resource "aws_route_table_association" "vpc_security_untrust1" {
  subnet_id      = "${aws_subnet.vpc_security_untrust1.id}"
  route_table_id = "${aws_route_table.vpc_security_untrust.id}"
}

resource "aws_route_table_association" "vpc_security_untrust2" {
  subnet_id      = "${aws_subnet.vpc_security_untrust2.id}"
  route_table_id = "${aws_route_table.vpc_security_untrust.id}"
}

resource "aws_route_table_association" "vpc_security_trust_1" {
  subnet_id      = "${aws_subnet.vpc_security_trust_1.id}"
  route_table_id = "${aws_route_table.vpc_security_trust.id}"
}

resource "aws_route_table_association" "vpc_security_trust_2" {
  subnet_id      = "${aws_subnet.vpc_security_trust_2.id}"
  route_table_id = "${aws_route_table.vpc_security_trust.id}"
}

resource "aws_route_table_association" "vpc_security_tgw_1" {
  subnet_id      = "${aws_subnet.vpc_security_tgw_1.id}"
  route_table_id = "${aws_route_table.vpc_security_tgw.id}"
}

resource "aws_route_table_association" "vpc_security_tgw_2" {
  subnet_id      = "${aws_subnet.vpc_security_tgw_2.id}"
  route_table_id = "${aws_route_table.vpc_security_tgw.id}"
}

resource "aws_route_table_association" "vpc_security_lambda_1" {
  subnet_id      = "${aws_subnet.vpc_security_lambda_1.id}"
  route_table_id = "${aws_route_table.vpc_security_lambda_1.id}"
}
resource "aws_route_table_association" "vpc_security_lambda_2" {
  subnet_id      = "${aws_subnet.vpc_security_lambda_2.id}"
  route_table_id = "${aws_route_table.vpc_security_lambda_2.id}"
}

#************************************************************************************
# CREATE NSGs & NSG RULES FOR FW MANAGEMENT ENI (22, 443, 3978-Panorama)
#************************************************************************************
resource "aws_security_group" "mgmt_nsg" {
  name        = "mgmt_nsg"
  description = "Allow HTTPS and SSH inbound traffic"
  vpc_id      = "${aws_vpc.vpc_security.id}"
}

resource "aws_security_group_rule" "mgmt_nsg_ingress_22" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["${var.management_cidr}"]

  security_group_id = "${aws_security_group.mgmt_nsg.id}"
}

resource "aws_security_group_rule" "mgmt_nsg_ingress_443" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["${var.management_cidr}"]

  security_group_id = "${aws_security_group.mgmt_nsg.id}"
}

resource "aws_security_group_rule" "mgmt_nsg_ingress_3978" {
  type        = "ingress"
  from_port   = 3978
  to_port     = 3978
  protocol    = "tcp"
  cidr_blocks = ["${var.management_cidr}"]

  security_group_id = "${aws_security_group.mgmt_nsg.id}"
}

resource "aws_security_group_rule" "mgmt_nsg_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.mgmt_nsg.id}"
}


#************************************************************************************
# CREATE NSG & NSG RULES FOR FW DATAPLANE ENIs
#************************************************************************************
resource "aws_security_group" "data_nsg" {
  name        = "data_nsg"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.vpc_security.id}"
}

resource "aws_security_group_rule" "data_nsg_ingress" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.data_nsg.id}"
}

resource "aws_security_group_rule" "data_nsg_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.data_nsg.id}"
}

#************************************************************************************
# CREATE NAT GATEWAYS
#************************************************************************************
resource "aws_eip" "eip-natgw1" {
  vpc               = true
  tags {
    Name = "eip_natgw1"
  }
}
resource "aws_eip" "eip-natgw2" {
  vpc               = true
  tags {
    Name = "eip_natgw2"
  }
}
resource "aws_nat_gateway" "natgw1" {

  allocation_id = "${aws_eip.eip-natgw1.id}"
  subnet_id     = "${aws_subnet.vpc_security_mgmt_1.id}"
  tags = {
    Name = "gw1 NAT"
  }
  depends_on = ["aws_internet_gateway.vpc_security_igw"]
}
resource "aws_nat_gateway" "natgw2" {

  allocation_id = "${aws_eip.eip-natgw2.id}"
  subnet_id     = "${aws_subnet.vpc_security_mgmt_2.id}"
  tags = {
    Name = "gw2 NAT"
  }
  depends_on = ["aws_internet_gateway.vpc_security_igw"]
}
  
  


#************************************************************************************
# CREATE FW1
#************************************************************************************
module "ngfw1" {
  source = "./modules/vm-series/"

  name = "vmseries-fw1"

  aws_key = "${var.aws_key}"

  trust_subnet_id         = "${aws_subnet.vpc_security_trust_1.id}"
  trust_security_group_id = "${aws_security_group.data_nsg.id}"
  trustfwip               = "${var.fw_ip_subnet_private_1}"

  untrust_subnet_id         = "${aws_subnet.vpc_security_untrust1.id}"
  untrust_security_group_id = "${aws_security_group.data_nsg.id}"
  untrustfwip               = "${var.fw_ip_subnet_public_1 }"

  management_subnet_id         = "${aws_subnet.vpc_security_mgmt_1.id}"
  management_security_group_id = "${aws_security_group.mgmt_nsg.id}"

  bootstrap_profile = "${aws_iam_instance_profile.bootstrap_profile.id}"
  bootstrap_bucket  = "${aws_s3_bucket.bootstrap_bucket_fw1.id}"

  tgw_id = "${aws_ec2_transit_gateway.tgw.id}"

  aws_region        = "${var.aws_region}"
  ngfw_license_type = "${var.ngfw_license_type}"
  instance_type     = "${var.instance_type}"
}


#************************************************************************************
# CREATE FW2
#************************************************************************************
module "ngfw2" {
  source = "./modules/vm-series/"

  name = "vmseries-fw2"

  aws_key = "${var.aws_key}"

  trust_subnet_id         = "${aws_subnet.vpc_security_trust_2.id}"
  trust_security_group_id = "${aws_security_group.data_nsg.id}"
  trustfwip               = "${var.fw_ip_subnet_private_2}"

  untrust_subnet_id         = "${aws_subnet.vpc_security_untrust2.id}"
  untrust_security_group_id = "${aws_security_group.data_nsg.id}"
  untrustfwip               = "${var.fw_ip_subnet_public_2 }"

  management_subnet_id         = "${aws_subnet.vpc_security_mgmt_2.id}"
  management_security_group_id = "${aws_security_group.mgmt_nsg.id}"

  bootstrap_profile = "${aws_iam_instance_profile.bootstrap_profile.id}"
  bootstrap_bucket  = "${aws_s3_bucket.bootstrap_bucket_fw2.id}"

  tgw_id = "${aws_ec2_transit_gateway.tgw.id}"

  aws_region        = "${var.aws_region}"
  ngfw_license_type = "${var.ngfw_license_type}"
  instance_type     = "${var.instance_type}"
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
