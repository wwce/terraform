resource "google_compute_health_check" "default" {
  name = "${var.name}-check-0"

  tcp_health_check {
    port = var.health_check_port
  }
}
resource "google_compute_region_backend_service" "default" {
  count         = length(var.backends)
  name          = "${var.name}-${count.index}"
  health_checks = [google_compute_health_check.default.self_link]

  dynamic "backend" {
    for_each = var.backends[count.index]
    content {
      group    = lookup(backend.value, "group")
      failover = lookup(backend.value, "failover")
    }
  }
  session_affinity = "NONE"
}

resource "google_compute_forwarding_rule" "default" {
  count                 = length(var.backends)
  name                  = "${var.name}-all-${count.index}"
  load_balancing_scheme = "INTERNAL"
  ip_address            = var.ip_address
  ip_protocol           = var.ip_protocol
  all_ports             = var.all_ports
  ports                 = var.ports
  subnetwork            = var.subnetworks[0]
  backend_service       = google_compute_region_backend_service.default[count.index].self_link
}
