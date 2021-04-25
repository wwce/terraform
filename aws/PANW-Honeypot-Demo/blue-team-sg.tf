#Security Groups
resource "aws_security_group" "blue_team_mgmt" {
  name        = "blue_team_mgmt"
  description = "Mgmt open security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["${var.mgmt_ip}"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "TCP"
    cidr_blocks = ["${var.mgmt_ip}"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "blue_team_mgmt"
  }
}

resource "aws_security_group" "blue_team_untrust" {
  name        = "blue_team_untrust"
  description = "Wide open security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = "221"
    to_port     = "223"
    protocol    = "TCP"
    cidr_blocks = ["${var.mgmt_ip}"]
  }
  
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = "23"
    to_port     = "23"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "blue_team_untrust"
  }
}

resource "aws_security_group" "blue_team_trust" {
  name        = "blue_team_trust"
  description = "Wide open security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "blue_team_trust"
  }
}