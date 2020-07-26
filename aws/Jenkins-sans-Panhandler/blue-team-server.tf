data "template_file" "server" {
  template = "${file("${path.root}${var.server_initscript_path}")}"
}

resource "aws_network_interface" "blue_team_server" {
  subnet_id         = "${aws_subnet.blue_team_az1_trust.id}"
  security_groups   = ["${aws_security_group.webserver.id}"]
  source_dest_check = false
  private_ips       = ["${var.blue_team_server_ip}"]
  tags = {
    Name = "blue_team_server"
  }
}

resource "aws_instance" "server" {
  # instance_initiated_shutdown_behavior = "stop"
  ami           = "${var.UbuntuRegionMap[var.aws_region]}"
  instance_type = "t2.micro"
  key_name      = "${var.aws_key_pair}"
  monitoring    = false

  tags = {
    Name = "blue_team_server"
  }

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.blue_team_server.id}"
  }

  user_data = "${data.template_file.server.template}"
}
