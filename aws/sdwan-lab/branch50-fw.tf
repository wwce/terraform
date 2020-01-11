resource "aws_network_interface" "branch50-fw-mgt" {
  subnet_id         = "${aws_subnet.SD-WAN-MGT.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = true
  private_ips       = ["100.64.0.50"]
}

resource "aws_network_interface" "branch50-fw-wan1" {
  subnet_id         = "${aws_subnet.SD-WAN-WAN1.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.1.50"]
}

resource "aws_network_interface" "branch50-fw-wan2" {
  subnet_id         = "${aws_subnet.SD-WAN-WAN2.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.2.50"]
}

resource "aws_network_interface" "branch50-fw-branch50" {
  subnet_id         = "${aws_subnet.SD-WAN-Branch50.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.50.254"]
}

resource "aws_network_interface" "branch50-fw-mpls" {
  subnet_id         = "${aws_subnet.SD-WAN-MPLS.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.5.50"]
}

resource "aws_eip_association" "branch50-fw-mgt-Association" {
  network_interface_id = "${aws_network_interface.branch50-fw-mgt.id}"
  allocation_id        = "${aws_eip.branch50-fw-mgt.id}"
}

#Deploys the firewalls

resource "aws_instance" "branch50-fw" {
  tags {
    Name = "Branch50-fw"
  }

  disable_api_termination = false

  ebs_optimized        = true
  ami                  = "${var.SD-WAN-BRANCH50-FW}"
  instance_type        = "m5.4xlarge"

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_type           = "gp2"
    delete_on_termination = true
    volume_size           = 60
  }

  key_name   = "${var.ServerKeyName}"
  monitoring = false

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.branch50-fw-mgt.id}"
  }

  network_interface {
    device_index         = 1
    network_interface_id = "${aws_network_interface.branch50-fw-wan1.id}"
  }

  network_interface {
    device_index         = 2
    network_interface_id = "${aws_network_interface.branch50-fw-wan2.id}"
  }

  network_interface {
    device_index         = 3
    network_interface_id = "${aws_network_interface.branch50-fw-branch50.id}"
  }

  network_interface {
    device_index         = 4
    network_interface_id = "${aws_network_interface.branch50-fw-mpls.id}"
  }
}