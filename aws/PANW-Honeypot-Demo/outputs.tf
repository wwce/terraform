output "FW1-MGMT-IP" {
  value = aws_eip.blue_team_ngfw_mgmt.public_ip
}

output "FW1-Untrust-IP" {
  value = aws_eip.blue_team_ngfw_untrust0.public_ip
}

output "Server1-IP" {
  value = aws_eip.blue_team_ngfw_untrust1.public_ip
}

output "Server2-IP" {
  value = aws_eip.blue_team_ngfw_untrust2.public_ip
}

output "Server3-IP" {
  value = aws_eip.blue_team_ngfw_untrust3.public_ip
}