output "MGT-IP-FW-1" {
  value = "${aws_eip.FW1-MGT.public_ip}"
}

output "NLB-DNS" {
  value = "${aws_lb.int-nlb.dns_name}"
}

output "ALB-DNS" {
  value = "${aws_lb.panos-alb.dns_name}"
}

output "NATIVE-DNS" {
  value = "${aws_lb.native-alb.dns_name}"
}

output "ATTACKER_IP" {
  value = "${aws_eip.kali.public_ip}"
}
