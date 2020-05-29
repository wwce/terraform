variable name {
  description = "firewall instance name"
}

variable untrust_subnet_id {}
variable untrust_security_group_id {}
variable untrustfwip {}

variable trust_subnet_id {}
variable trust_security_group_id {}
variable trustfwip {}

variable management_subnet_id {}
variable management_security_group_id {}

variable bootstrap_profile {
  default = ""
}

variable bootstrap_s3bucket {}

variable tgw_id {}

variable aws_region {}
variable aws_key {}

variable instance_type {
  default = "m4.2xlarge"
}

variable ngfw_license_type {
  default = "payg2"
}

variable ngfw_version {
  default = "8.1"
}

variable "license_type_map" {
  type = "map"

  default = {
    "byol"  = "6njl1pau431dv1qxipg63mvah"
    "payg1" = "6kxdw3bbmdeda3o6i1ggqt4km"
    "payg2" = "806j2of0qy5osgjjixq9gqc6g"
  }
}

data "aws_ami" "panw_ngfw" {
  most_recent = true
  owners = ["aws-marketplace"]
  filter {
    name   = "owner-alias"
    values = ["aws-marketplace"]
  }

  filter {
    name   = "product-code"
    values = ["${var.license_type_map[var.ngfw_license_type]}"]
  }

  filter {
    name   = "name"
    values = ["PA-VM-AWS-${var.ngfw_version}*"]
  }
}

data "aws_region" "current" {
  name = "${var.aws_region}"
}

resource "aws_network_interface" "eni-management" {
  subnet_id         = "${var.management_subnet_id}"
  security_groups   = ["${var.management_security_group_id}"]
  source_dest_check = true

  tags {
    Name = "eni_${var.name}_management"
  }
}

resource "aws_network_interface" "eni-trust" {
  subnet_id         = "${var.trust_subnet_id}"
  private_ips       = ["${var.trustfwip}"]
  security_groups   = ["${var.trust_security_group_id}"]
  source_dest_check = false

  tags {
    Name = "eni_${var.name}_trust"
  }
}

output "eni-trust" {
  value = "${aws_network_interface.eni-trust.id}"
}

resource "aws_eip" "eip-management" {
  vpc               = true
  network_interface = "${aws_network_interface.eni-management.id}"

  tags {
    Name = "eip_${var.name}_management"
  }
}

resource "aws_network_interface" "eni-untrust" {
  subnet_id         = "${var.untrust_subnet_id}"
  private_ips       = ["${var.untrustfwip}"]
  security_groups   = ["${var.untrust_security_group_id}"]
  source_dest_check = false

  tags {
    Name = "eni_${var.name}_untrust"
  }
}

resource "aws_eip" "eip-untrust" {
  vpc               = true
  network_interface = "${aws_network_interface.eni-untrust.id}"

  tags {
    Name = "eip_${var.name}_untrust"
  }
}

resource "aws_instance" "instance-ngfw" {
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "stop"
  iam_instance_profile                 = "${var.bootstrap_profile}"
  user_data                            = "${base64encode(join("", list("vmseries-bootstrap-aws-s3bucket=", var.bootstrap_s3bucket)))}"

  ebs_optimized = true
  ami           = "${data.aws_ami.panw_ngfw.image_id}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.aws_key}"

  monitoring = false

  network_interface {
    device_index         = 1
    network_interface_id = "${aws_network_interface.eni-management.id}"
  }

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.eni-untrust.id}"
  }

  network_interface {
    device_index         = 2
    network_interface_id = "${aws_network_interface.eni-trust.id}"
  }

  tags {
    Name = "${var.name}"
  }
}

output "eip_untrust" {
  value = "${aws_eip.eip-untrust.public_ip}"
}

output "eip_mgmt" {
  value = "${aws_eip.eip-management.public_ip}"
}
