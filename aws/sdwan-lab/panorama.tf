resource "aws_network_interface" "panorama" {
  subnet_id         = "${aws_subnet.SD-WAN-MGT.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = true
  private_ips       = ["100.64.0.40"]
}

resource "aws_eip_association" "panorama-mgt-Association" {
  network_interface_id = "${aws_network_interface.panorama.id}"
  allocation_id        = "${aws_eip.panorama-mgt.id}"
}

#Deploys panorama

resource "aws_instance" "panorama" {
  tags {
    Name = "panorama"
  }

  disable_api_termination = false

  ebs_optimized        = true
  ami                  = "${var.PanoramaRegionMap[var.aws_region]}"
  instance_type        = "m5.4xlarge"

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_type           = "gp2"
    delete_on_termination = true
    volume_size           = 81
  }

  ebs_block_device {
    device_name           = "/dev/xvdb"
    volume_type           = "gp2"
    delete_on_termination = true
    volume_size           = 200
  }

  key_name   = "${var.ServerKeyName}"
  monitoring = false

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.panorama.id}"
  }

}
