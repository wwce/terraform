output "vm_names" {
  value = google_compute_instance.vmseries.*.name
}

output "vm_self_link" {
  value = google_compute_instance.vmseries.*.self_link
}

output "instance_group" {
  value = google_compute_instance_group.vmseries.*.self_link
}

output "nic0_public_ip" {
  value = var.nic0_public_ip ? google_compute_instance.vmseries.*.network_interface.0.access_config.0.nat_ip : []
}

output "nic1_public_ip" {
  value = var.nic1_public_ip ? google_compute_instance.vmseries.*.network_interface.1.access_config.0.nat_ip : []
}

output "nic2_public_ip" {
  value = var.nic2_public_ip ? google_compute_instance.vmseries.*.network_interface.2.access_config.0.nat_ip : []
}

