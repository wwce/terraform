resource "aws_security_group" "allow-all" {
  name        = "allow-all"
  description = "Wide open security group"
  vpc_id      = "${aws_vpc.SDWAN.id}"

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
    Name = "allow-all"
  }
}