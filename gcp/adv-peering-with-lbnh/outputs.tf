#************************************************************************************
# OUTPUTS
#************************************************************************************
output "                             IMPORTANT!! PLEASE READ!!                                    " {
  value = [
      "===================================================================================",
      "Before proceeding, you must enable import/export custom routes on all peering links",
      "and remove the default (0.0.0.0/0) route from TRUST, SPOKE1, and SPOKE2 VPCs",
      "There is also a need to create a default route in the ilb-trust-subnet pointing to",
      "the internal load balancer",
      "==================================================================================="]
}
output "GLB-ADDRESS   " {
  value = "http://${module.vmseries_public_lb.address}"
}

output "MGMT-URL-FW1  " {
  value = "https://${module.vm_fw.fw_nic1_public_ip[0]}"
}

output "MGMT-URL-FW2  " {
  value = "https://${module.vm_fw.fw_nic1_public_ip[1]}"
}
output "MGMT-URL-ILB-FW3 " {
  value = "https://${module.vm_fw_ilbnh.fw_nic1_public_ip[0]}"
}

output "MGMT-URL-ILB-FW4  " {
  value = "https://${module.vm_fw_ilbnh.fw_nic1_public_ip[1]}"
}
output "SSH-SPOKE1-VM1-FW1" {
  value = "ssh ubuntu@${module.vm_fw.fw_nic0_public_ip[0]} -p 221 -i <INSERT KEY>"
}

output "SSH-SPOKE1-VM2-FW1" {
  value = "ssh ubuntu@${module.vm_fw.fw_nic0_public_ip[0]} -p 222 -i <INSERT KEY>"
}

output "SSH-SPOKE2-FW1" {
  value = "ssh ubuntu@${module.vm_fw.fw_nic0_public_ip[0]} -p 223 -i <INSERT KEY>"
}

output "SSH-SPOKE1-VM1-FW2" {
  value = "ssh ubuntu@${module.vm_fw.fw_nic0_public_ip[1]} -p 221 -i <INSERT KEY>"
}
output "SSH-SPOKE1-VM2-FW2" {
  value = "ssh ubuntu@${module.vm_fw.fw_nic0_public_ip[1]} -p 222 -i <INSERT KEY>"
}

output "SSH-SPOKE2-FW2" {
  value = "ssh ubuntu@${module.vm_fw.fw_nic0_public_ip[1]} -p 223 -i <INSERT KEY>"
}
