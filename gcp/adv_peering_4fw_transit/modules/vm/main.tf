resource "google_compute_instance" "vm" {
  count                     = length(var.names)
  name                      = element(var.names, count.index)
  machine_type              = var.machine_type
  zone                      = element(var.zones, count.index)
  can_ip_forward            = true
  allow_stopping_for_update = true
  metadata_startup_script   = var.startup_script

  metadata = {
    serial-port-enable = true
    #sshKeys            = var.ssh_key
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


resource "google_compute_instance_group" "instance_group" {
  count = var.internal_lb_create
  name  = "${element(var.names, count.index)}-${element(var.zones, count.index)}-ig"
  zone  = var.zones[0]

  instances = google_compute_instance.vm.*.self_link
}

resource "google_compute_health_check" "health_check" {
  count = var.internal_lb_create
  name  = "${var.internal_lb_name}-check"

  tcp_health_check {
    port = var.internal_lb_ports[0]
  }
}

resource "google_compute_region_backend_service" "backend_service" {
  count         = var.internal_lb_create
  name          = var.internal_lb_name
  health_checks = [google_compute_health_check.health_check[0].self_link]

  backend {
    group = google_compute_instance_group.instance_group[0].self_link
  }
}

resource "google_compute_forwarding_rule" "forwarding_rule" {
  count                 = var.internal_lb_create
  name                  = "${var.internal_lb_name}-tcp"
  load_balancing_scheme = "INTERNAL"
  ip_address            = var.internal_lb_ip
  ports                 = var.internal_lb_ports
  subnetwork            = var.subnetworks[0]
  backend_service       = google_compute_region_backend_service.backend_service[0].self_link
}

