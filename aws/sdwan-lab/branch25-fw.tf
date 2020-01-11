resource "aws_network_interface" "branch25-fw-mgt" {
  subnet_id         = "${aws_subnet.SD-WAN-MGT.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = true
  private_ips       = ["100.64.0.25"]
}

resource "aws_network_interface" "branch25-fw-wan1" {
  subnet_id         = "${aws_subnet.SD-WAN-WAN1.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.1.25"]
}

resource "aws_network_interface" "branch25-fw-wan2" {
  subnet_id         = "${aws_subnet.SD-WAN-WAN2.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.2.25"]
}

resource "aws_network_interface" "branch25-fw-branch25" {
  subnet_id         = "${aws_subnet.SD-WAN-Branch25.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.25.254"]
}

resource "aws_network_interface" "branch25-fw-mpls" {
  subnet_id         = "${aws_subnet.SD-WAN-MPLS.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.5.25"]
}

resource "aws_eip_association" "branch25-fw-mgt-Association" {
  network_interface_id = "${aws_network_interface.branch25-fw-mgt.id}"
  allocation_id        = "${aws_eip.branch25-fw-mgt.id}"
}

#Deploys the firewalls

resource "aws_instance" "branch25-fw" {
  tags {
    Name = "Branch25-fw"
  }

  disable_api_termination = false

  ebs_optimized        = true
  ami                  = "${var.SD-WAN-BRANCH25-FW}"
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
    network_interface_id = "${aws_network_interface.branch25-fw-mgt.id}"
  }

  network_interface {
    device_index         = 1
    network_interface_id = "${aws_network_interface.branch25-fw-wan1.id}"
  }

  network_interface {
    device_index         = 2
    network_interface_id = "${aws_network_interface.branch25-fw-wan2.id}"
  }

  network_interface {
    device_index         = 3
    network_interface_id = "${aws_network_interface.branch25-fw-branch25.id}"
  }

  network_interface {
    device_index         = 4
    network_interface_id = "${aws_network_interface.branch25-fw-mpls.id}"
  }
}