#Security Groups
resource "aws_security_group" "blue_team_mgmt" {
  name        = "blue_team_mgmt"
  description = "Mgmt open security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = "0"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["${var.mgmt_ip}"]
  }

  ingress {
    from_port   = "0"
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

resource "aws_security_group" "blue_team_open" {
  name        = "blue_team_open"
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
    Name = "blue_team_open"
  }
}