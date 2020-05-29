output "Portal-Management-IP" {
  value = "${google_compute_instance.portal.network_interface.1.access_config.0.nat_ip}"
}

output "Gateway1-Management-IP" {
  value = "${google_compute_instance.gateway1.network_interface.1.access_config.0.nat_ip}"
}

output "Gateway2-Management-IP" {
  value = "${google_compute_instance.gateway2.network_interface.1.access_config.0.nat_ip}"
}