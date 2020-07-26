output "FW1-MGMT-IP" {
  value = "${aws_eip.blue_team_ngfw_mgmt.public_ip}"
}

output "NGFW-ALB" {
  value = "${aws_lb.ngfw-alb.dns_name}"
}

output "Native-ALB" {
  value = "${aws_lb.native-alb.dns_name}"
}

output "Internal-NLB" {
  value = "${aws_lb.int-nlb.dns_name}"
}

output "Attacker-IP" {
  value = "${aws_eip.red_team.public_ip}"
}

output "FW1-Untrust-IP" {
  value = "${aws_eip.blue_team_ngfw_untrust.public_ip}"
}