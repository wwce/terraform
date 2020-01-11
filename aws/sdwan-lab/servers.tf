resource "aws_network_interface" "SD-WAN-Branch25-MGT" {
  subnet_id         = "${aws_subnet.SD-WAN-MGT.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.0.249"]
}

resource "aws_network_interface" "SD-WAN-Branch25-IWS" {
  subnet_id         = "${aws_subnet.SD-WAN-Branch25.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.25.50"]
}

resource "aws_instance" "SD-WAN-Branch25-IWS" {
  ami           = "${var.SD-WAN-BRANCH25-IWS}"
  instance_type = "t2.large"
  key_name      = "${var.ServerKeyName}"
  monitoring    = false

  tags {
    Name = "SD-WAN-Branch25-IWS"
  }

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.SD-WAN-Branch25-MGT.id}"
  }

  network_interface {
    device_index         = 1
    network_interface_id = "${aws_network_interface.SD-WAN-Branch25-IWS.id}"
  }
}

resource "aws_network_interface" "SD-WAN-Branch50-MGT" {
  subnet_id         = "${aws_subnet.SD-WAN-MGT.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.0.49"]
}

resource "aws_network_interface" "SD-WAN-Branch50-IWS" {
  subnet_id         = "${aws_subnet.SD-WAN-Branch50.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.50.50"]
}

resource "aws_instance" "SD-WAN-Branch50-IWS" {
  ami           = "${var.SD-WAN-BRANCH50-IWS}"
  instance_type = "t2.large"
  key_name      = "${var.ServerKeyName}"
  monitoring    = false

  tags {
    Name = "SD-WAN-Branch50-IWS"
  }

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.SD-WAN-Branch50-MGT.id}"
  }

  network_interface {
    device_index         = 1
    network_interface_id = "${aws_network_interface.SD-WAN-Branch50-IWS.id}"
  }
}

resource "aws_network_interface" "SD-WAN-Hub-SVR-MGT" {
  subnet_id         = "${aws_subnet.SD-WAN-MGT.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.0.149"]
}

resource "aws_network_interface" "SD-WAN-Hub-SVR" {
  subnet_id         = "${aws_subnet.SD-WAN-Hub.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.255.50"]
}

resource "aws_instance" "SD-WAN-Hub-SVR" {
  ami           = "${var.SD-WAN-HUB-SVR}"
  instance_type = "t2.large"
  key_name      = "${var.ServerKeyName}"
  monitoring    = false

  tags {
    Name = "SD-WAN-Hub-SVR"
  }

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.SD-WAN-Hub-SVR-MGT.id}"
  }

  network_interface {
    device_index         = 1
    network_interface_id = "${aws_network_interface.SD-WAN-Hub-SVR.id}"
  }
}

resource "aws_network_interface" "SD-WAN-Router-Jitter-MGT" {
  subnet_id         = "${aws_subnet.SD-WAN-MGT.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.0.100"]
}

resource "aws_network_interface" "SD-WAN-Router-Jitter-WAN1" {
  subnet_id         = "${aws_subnet.SD-WAN-WAN1.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.1.100"]
}

resource "aws_network_interface" "SD-WAN-Router-Jitter-WAN2" {
  subnet_id         = "${aws_subnet.SD-WAN-WAN2.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.2.100"]
}

resource "aws_network_interface" "SD-WAN-Router-Jitter-WAN3" {
  subnet_id         = "${aws_subnet.SD-WAN-WAN3.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.3.100"]
}

resource "aws_network_interface" "SD-WAN-Router-Jitter-WAN4" {
  subnet_id         = "${aws_subnet.SD-WAN-WAN4.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.4.100"]
}

resource "aws_network_interface" "SD-WAN-Router-Jitter-MPLS" {
  subnet_id         = "${aws_subnet.SD-WAN-MPLS.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.5.100"]
}

resource "aws_instance" "SD-WAN-Router-Jitter" {
  # instance_initiated_shutdown_behavior = "stop"
  ami           = "${var.SD-WAN-ROUTER-JITTER}"
  instance_type = "m5.4xlarge"
  key_name      = "${var.ServerKeyName}"
  monitoring    = false

  tags {
    Name = "SD-WAN-Router-Jitter"
  }

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.SD-WAN-Router-Jitter-MGT.id}"
  }

  network_interface {
    device_index         = 1
    network_interface_id = "${aws_network_interface.SD-WAN-Router-Jitter-WAN1.id}"
  }

  network_interface {
    device_index         = 2
    network_interface_id = "${aws_network_interface.SD-WAN-Router-Jitter-WAN2.id}"
  }

  network_interface {
    device_index         = 3
    network_interface_id = "${aws_network_interface.SD-WAN-Router-Jitter-WAN3.id}"
  }

  network_interface {
    device_index         = 4
    network_interface_id = "${aws_network_interface.SD-WAN-Router-Jitter-WAN4.id}"
  }

  network_interface {
    device_index         = 5
    network_interface_id = "${aws_network_interface.SD-WAN-Router-Jitter-MPLS.id}"
  }
}