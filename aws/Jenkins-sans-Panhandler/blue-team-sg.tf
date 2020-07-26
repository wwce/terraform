#Security Groups
resource "aws_security_group" "blue_team_open" {
  name        = "blue_team_open"
  description = "Wide open security group"
  vpc_id      = "${aws_vpc.main.id}"

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

resource "aws_security_group" "webserver" {
  name        = "blue_team_server"
  description = "blue_team web server"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["${var.blue_team_cidr}"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["${var.blue_team_cidr}"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["${var.blue_team_cidr}"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "blue_team_server"
  }
}
