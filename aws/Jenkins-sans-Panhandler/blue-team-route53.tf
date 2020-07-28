resource "aws_route53_zone" "private" {
  name = "blue-team.local"

  vpc {
    vpc_id = "${aws_vpc.main.id}"
  }
}

resource "aws_route53_record" "int-nlb" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "int-nlb"
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "int-nlb"
  records        = ["${aws_lb.int-nlb.dns_name}"]
}