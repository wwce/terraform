resource "google_compute_instance" "default" {
  count                     = length(var.names)
  name                      = element(var.names, count.index)
  machine_type              = var.machine_type
  zone                      = element(var.zones, count.index)
  can_ip_forward            = true
  allow_stopping_for_update = true
  metadata_startup_script   = var.startup_script

  metadata = {
    serial-port-enable = true
    ssh-keys           = var.ssh_key
  }

  network_interface {
    subnetwork = element(var.subnetworks, count.index)
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


resource "google_compute_instance_group" "default" {
  count     = var.create_instance_group ? length(var.names) : 0
  name      = "${element(var.names, count.index)}-${element(var.zones, count.index)}-ig"
  zone      = element(var.zones, count.index)
  instances = [google_compute_instance.default[count.index].self_link]

  named_port {
    name = "http"
    port = "80"
  }

  lifecycle {
    create_before_destroy = true
  }
}
