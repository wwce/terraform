resource "aws_network_interface" "ion-public1" {
  count = var.ENV_COUNT
  subnet_id       = aws_subnet.sdwan-lab-public1.id
  security_groups = [aws_security_group.ion-pub-vpn-ssh.id]
  tags = {
        Name = "ion Public Subnet 1"
  }
}

resource "aws_network_interface" "ion-lan" {
  count = var.ENV_COUNT
  subnet_id       = aws_subnet.sdwan-lab-private[count.index].id
  security_groups = [aws_security_group.ion-internal-any-any.id]
  source_dest_check = "false"
  tags = {
        Name = "ion LAN Subnet"
  }
}

resource "aws_network_interface" "ion-controller" {
  count = var.ENV_COUNT
  subnet_id       = aws_subnet.sdwan-lab-private[count.index].id
  security_groups = [aws_security_group.ion-internal-any-any.id]
  tags = {
        Name = "ion Mgmt Subnet"
  }
}

resource "aws_network_interface" "tgen-lan" {
  count = var.ENV_COUNT
  subnet_id       = aws_subnet.sdwan-lab-private[count.index].id
  security_groups = [aws_security_group.ion-internal-any-any.id]
  private_ips_count = var.TGEN_INSTANCE_ADDITIONAL_IPS
  tags = {
        Name = "tgen LAN Subnet"
  }
}

output "ion_controller" {
    value = aws_network_interface.ion-controller
    description = "ION controller Interfaces"
}

resource "aws_eip" "ion-public1" {
  vpc   = true
  tags = {
    Name = "ion Public Subnet 1"
  }
}

resource "aws_eip" "ion-controller" {
  vpc   = true
  tags = {
    Name = "ion LAN Subnet"
  }
}

resource "aws_eip_association" "ion-public1-association" {
  network_interface_id = aws_network_interface.ion-public1[0].id
  allocation_id        = aws_eip.ion-public1.id
}

resource "aws_eip_association" "ion-controller-association" {
  network_interface_id = aws_network_interface.ion-controller[0].id
  allocation_id        = aws_eip.ion-controller.id
}