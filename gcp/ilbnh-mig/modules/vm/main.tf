resource "google_compute_instance" "default" {
  count                     = length(var.names)
  name                      = element(var.names, count.index)
  machine_type              = var.machine_type
  zone                      = element(var.zones, count.index)
  can_ip_forward            = false
  allow_stopping_for_update = true
  metadata_startup_script   = var.startup_script

  metadata = {
    serial-port-enable = true
    ssh-keys           = var.ssh_key
  }

  network_interface {
    dynamic "access_config" {
      for_each = var.server_public_ip ? [""] : []
      content {}
    }
    subnetwork = element(var.subnetworks, count.index)
    network_ip = element(var.server_ips, count.index)

  }

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  service_account {
    scopes = var.scopes
  }
}