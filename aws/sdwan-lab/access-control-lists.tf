resource "aws_network_acl" "allow-all" {
  vpc_id = "${aws_vpc.SDWAN.id}"
  subnet_ids = ["${aws_subnet.SD-WAN-MGT.id}","${aws_subnet.SD-WAN-WAN1.id}","${aws_subnet.SD-WAN-WAN2.id}","${aws_subnet.SD-WAN-WAN3.id}","${aws_subnet.SD-WAN-WAN4.id}","${aws_subnet.SD-WAN-MPLS.id}","${aws_subnet.SD-WAN-Branch25.id}","${aws_subnet.SD-WAN-Branch50.id}","${aws_subnet.SD-WAN-Hub.id}",]

  egress {
    protocol   = "-1"
    rule_no    = 2
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 1
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags {
    Name = "allow-all"
  }
}