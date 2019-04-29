output "FW_Mgmt_IP" {
  value = "${google_compute_instance.firewall.network_interface.1.access_config.0.nat_ip}"
}
output "ALB-DNS" {
  value = "${google_compute_url_map.firewalls.self_link}"
}