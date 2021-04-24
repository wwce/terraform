resource "aws_eip" "blue_team_ngfw_untrust0" {
  vpc                       = true
  network_interface         = aws_network_interface.blue_team_ngfw_untrust.id
  associate_with_private_ip = var.fw_untrust_ip0
  depends_on = [
    aws_vpc.main,
    aws_internet_gateway.blue_team_igw,
  ]
  tags = {
    Name = "blue_team_ngfw_untrust0"
  }
}

resource "aws_eip" "blue_team_ngfw_untrust1" {
  vpc                       = true
  network_interface         = aws_network_interface.blue_team_ngfw_untrust.id
  associate_with_private_ip = var.fw_untrust_ip1
  depends_on = [
    aws_vpc.main,
    aws_internet_gateway.blue_team_igw,
  ]
  tags = {
    Name = "blue_team_ngfw_untrust1"
  }
}

resource "aws_eip" "blue_team_ngfw_untrust2" {
  vpc                       = true
  network_interface         = aws_network_interface.blue_team_ngfw_untrust.id
  associate_with_private_ip = var.fw_untrust_ip2
  depends_on = [
    aws_vpc.main,
    aws_internet_gateway.blue_team_igw,
  ]
  tags = {
    Name = "blue_team_ngfw_untrust2"
  }
}

resource "aws_eip" "blue_team_ngfw_untrust3" {
  vpc                       = true
  network_interface         = aws_network_interface.blue_team_ngfw_untrust.id
  associate_with_private_ip = var.fw_untrust_ip3
  depends_on = [
    aws_vpc.main,
    aws_internet_gateway.blue_team_igw,
  ]
  tags = {
    Name = "blue_team_ngfw_untrust3"
  }
}

resource "aws_eip" "blue_team_ngfw_mgmt" {
  vpc                       = true
  network_interface         = aws_network_interface.blue_team_ngfw_mgmt.id
  associate_with_private_ip = var.fw_mgmt_ip
  depends_on = [
    aws_vpc.main,
    aws_internet_gateway.blue_team_igw,
  ]
  tags = {
    Name = "blue_team_ngfw_mgmt"
  }
}