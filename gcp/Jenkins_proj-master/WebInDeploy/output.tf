output "FW_Mgmt_IP" {
  value = "${google_compute_instance.firewall.network_interface.1.access_config.0.nat_ip}"
}

output "ALB-DNS" {
  value = "${google_compute_global_forwarding_rule.firewalls.ip_address}"
}

output "NATIVE-DNS" {
  value = "${google_compute_global_forwarding_rule.webservers.ip_address}"
}

output "ATTACKER_IP" {
  value = "${google_compute_instance.attacker.network_interface.0.access_config.0.nat_ip}"
}
