resource "aws_network_interface" "console-int" {
  subnet_id         = "${aws_subnet.AZ1-MGT.id}"
  security_groups   = ["${aws_security_group.sgWideOpen.id}"]
  source_dest_check = false
  private_ips       = ["10.0.0.10"]
}

resource "aws_eip_association" "console-Association" {
  network_interface_id = "${aws_network_interface.console-int.id}"
  allocation_id        = "${aws_eip.CONSOLE-MGT.id}"
}

resource "aws_instance" "twistlock-console" {
  # instance_initiated_shutdown_behavior = "stop"
  ami           = "${var.UbuntuRegionMap[var.aws_region]}"
  instance_type = "t2.xlarge"
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
   "#! /bin/bash\n",
          "sudo cd /var/tmp\n",
          "sudo wget -O initialize_console.sh https://raw.githubusercontent.com/wwce/terraform/twistlck/aws/Jenkins_proj-master/WebInDeploy/scripts/initialise_console.sh\n",
          "sudo chmod 755 initialize_console.sh &&\n",
          "sudo bash ./initialize_console.sh\n"
   )))
   }"
}
