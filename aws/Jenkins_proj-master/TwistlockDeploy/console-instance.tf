resource "aws_network_interface" "console-int" {
  subnet_id         = "${aws_subnet.AZ1-console.id}"
  security_groups   = ["${aws_security_group.consoleWideOpen.id}"]
  source_dest_check = false
  private_ips       = ["${var.AZ1_console_ip}"]
}

resource "aws_eip_association" "console-Association" {
  network_interface_id = "${aws_network_interface.console-int.id}"
  allocation_id        = "${aws_eip.CONSOLE-MGT.id}"
}

resource "aws_instance" "twistlock-console" {
  # instance_initiated_shutdown_behavior = "stop"
  ami           = "${var.UbuntuRegionMap[var.aws_region]}"
  instance_type = "t2.small"
  key_name      = "${var.ServerKeyName}"
  monitoring    = false

  tags {
    Name = "twistlock-console-AZ1"
  }

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.console-int.id}"
  }
  root_block_device {
      volume_size = 30
  }

  user_data = "${base64encode(join("", list(
   "#!/bin/bash\n",
          "cd /var/tmp\n",
          "sudo wget -O initialize_console.sh https://raw.githubusercontent.com/wwce/terraform/twistlck/aws/Jenkins_proj-master/WebInDeploy/scripts/initialise_console.sh &&\n",
          "sudo chmod 755 /var/tmp/initialize_console.sh &&\n",
          "sudo bash /var/tmp/initialize_console.sh <cdn-url>\n"
   )))
   }"
}
