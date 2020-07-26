data "template_file" "attacker" {
  template = "${file("${path.root}${var.attacker_initscript_path}")}"
}

resource "aws_network_interface" "red_team_server" {
  subnet_id         = "${aws_subnet.red_team_az1.id}"
  security_groups   = ["${aws_security_group.red_team_open.id}"]
  source_dest_check = false
  private_ips       = ["${var.red_team_ip}"]
  
  tags = {
    Name = "red_team_server"
  }
}

resource "aws_eip_association" "red_team_association" {
  network_interface_id = "${aws_network_interface.red_team_server.id}"
  allocation_id        = "${aws_eip.red_team.id}"
}

resource "aws_instance" "red_team" {
  #  instance_initiated_shutdown_behavior = "stop"
  ami           = "${var.UbuntuRegionMap[var.aws_region]}"
  instance_type = "t2.micro"
  key_name      = "${var.aws_key_pair}"
  monitoring    = false

  tags = {
    Name = "red_team_server"
  }

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.red_team_server.id}"
  }

  user_data = "${data.template_file.attacker.template}"

}
