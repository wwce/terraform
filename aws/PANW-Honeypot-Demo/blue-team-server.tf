data "template_file" "server1" {
  template = file("${path.root}${var.server1_initscript_path}")
}

resource "aws_network_interface" "blue_team_server1" {
  subnet_id         = aws_subnet.blue_team_trust.id
  security_groups   = [aws_security_group.blue_team_open.id]
  source_dest_check = false
  private_ips       = [var.blue_team_server1_ip]
  tags = {
    Name = "blue_team_server1"
  }
}

resource "aws_instance" "server1" {
  # instance_initiated_shutdown_behavior = "stop"
  ami           = var.UbuntuRegionMap[var.aws_region]
  instance_type = "t2.micro"
  key_name      = var.aws_key_pair
  monitoring    = false

  tags = {
    Name = "blue_team_server1"
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.blue_team_server1.id
  }

  user_data = data.template_file.server1.template
}

data "template_file" "server2" {
  template = file("${path.root}${var.server2_initscript_path}")
}

resource "aws_network_interface" "blue_team_server2" {
  subnet_id         = aws_subnet.blue_team_trust.id
  security_groups   = [aws_security_group.blue_team_open.id]
  source_dest_check = false
  private_ips       = [var.blue_team_server2_ip]
  tags = {
    Name = "blue_team_server2"
  }
}

resource "aws_instance" "server2" {
  # instance_initiated_shutdown_behavior = "stop"
  ami           = var.UbuntuRegionMap[var.aws_region]
  instance_type = "t2.micro"
  key_name      = var.aws_key_pair
  monitoring    = false

  tags = {
    Name = "blue_team_server2"
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.blue_team_server2.id
  }

  user_data = data.template_file.server2.template
}

data "template_file" "server3" {
  template = file("${path.root}${var.server3_initscript_path}")
}

resource "aws_network_interface" "blue_team_server3" {
  subnet_id         = aws_subnet.blue_team_trust.id
  security_groups   = [aws_security_group.blue_team_open.id]
  source_dest_check = false
  private_ips       = [var.blue_team_server3_ip]
  tags = {
    Name = "blue_team_server3"
  }
}

resource "aws_instance" "server3" {
  # instance_initiated_shutdown_behavior = "stop"
  ami           = var.UbuntuRegionMap[var.aws_region]
  instance_type = "t2.micro"
  key_name      = var.aws_key_pair
  monitoring    = false

  tags = {
    Name = "blue_team_server3"
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.blue_team_server3.id
  }

  user_data = data.template_file.server3.template
}

