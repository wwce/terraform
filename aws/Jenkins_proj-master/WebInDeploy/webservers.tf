resource "aws_network_interface" "web1-int" {
  subnet_id         = "${aws_subnet.AZ1-TRUST.id}"
  security_groups   = ["${aws_security_group.webserver.id}"]
  source_dest_check = false
  private_ips       = ["${var.WebSRV1_AZ1_Trust}"]
}

#resource "aws_eip_association" "webserver-Association" {
#  network_interface_id = "${aws_network_interface.web1-int.id}"
#  allocation_id        = "${aws_eip.webserver.id}"
#}

resource "aws_instance" "web1" {
  # instance_initiated_shutdown_behavior = "stop"
  ami           = "${var.UbuntuRegionMap[var.aws_region]}"
  instance_type = "t2.micro"
  key_name      = "${var.ServerKeyName}"
  monitoring    = false

  tags {
    Name = "WEB-AZ1"
  }

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.web1-int.id}"
  }

  user_data = "${base64encode(join("", list(
   "#! /bin/bash\n",
          "sudo su\n",
          "apt-get update\n",
          "apt-get update\n",
          "apt install docker.io python3-pip -y --force-yes\n",
          "pip3 install docker-compose\n",
          "cd /var/tmp\n",
          "wget https://raw.githubusercontent.com/wwce/terraform/master/aws/Jenkins_proj-master/jenkins/Dockerfile\n",
          "wget https://raw.githubusercontent.com/wwce/terraform/master/aws/Jenkins_proj-master/jenkins/docker-compose.yml\n",
          "wget https://raw.githubusercontent.com/wwce/terraform/master/aws/Jenkins_proj-master/jenkins/jenkins.sh\n",
          "docker-compose build\n",
          "docker-compose up -d\n"
   )))
   }"
}
