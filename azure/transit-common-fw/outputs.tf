output "MGMT-FW1" {
  value = "https://${module.vmseries.nic0_public_ip[0]}"
}

output "MGMT-FW2" {
  value = "https://${module.vmseries.nic0_public_ip[1]}"
}

output "SSH-TO-SPOKE1" {
  value = "ssh ${var.spoke_user}@${module.public_lb.public_ip[0]}"
}