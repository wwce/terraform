output "IP FW MGMT " {
  value = "${google_compute_instance.firewall.network_interface.1.access_config.0.nat_ip}"
}
