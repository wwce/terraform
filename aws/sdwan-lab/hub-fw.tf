resource "aws_network_interface" "hub-fw-mgt" {
  subnet_id         = "${aws_subnet.SD-WAN-MGT.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = true
  private_ips       = ["100.64.0.254"]
}

resource "aws_network_interface" "hub-fw-wan3" {
  subnet_id         = "${aws_subnet.SD-WAN-WAN3.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.3.254"]
}

resource "aws_network_interface" "hub-fw-wan4" {
  subnet_id         = "${aws_subnet.SD-WAN-WAN4.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.4.254"]
}

resource "aws_network_interface" "hub-fw-hub" {
  subnet_id         = "${aws_subnet.SD-WAN-Hub.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.255.254"]
}

resource "aws_network_interface" "hub-fw-mpls" {
  subnet_id         = "${aws_subnet.SD-WAN-MPLS.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.5.254"]
}

resource "aws_eip_association" "hub-fw-mgt-Association" {
  network_interface_id = "${aws_network_interface.hub-fw-mgt.id}"
  allocation_id        = "${aws_eip.hub-fw-mgt.id}"
}

#Deploys the firewalls

resource "aws_instance" "hub-fw" {
  tags {
    Name = "Hub-fw"
  }

  disable_api_termination = false

  ebs_optimized        = true
  ami                  = "${var.SD-WAN-HUB-FW}"
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
    network_interface_id = "${aws_network_interface.hub-fw-mgt.id}"
  }

  network_interface {
    device_index         = 1
    network_interface_id = "${aws_network_interface.hub-fw-wan3.id}"
  }

  network_interface {
    device_index         = 2
    network_interface_id = "${aws_network_interface.hub-fw-wan4.id}"
  }

  network_interface {
    device_index         = 3
    network_interface_id = "${aws_network_interface.hub-fw-hub.id}"
  }

  network_interface {
    device_index         = 4
    network_interface_id = "${aws_network_interface.hub-fw-mpls.id}"
  }
}