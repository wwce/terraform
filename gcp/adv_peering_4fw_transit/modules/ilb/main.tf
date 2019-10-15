resource "google_compute_health_check" "main" {
  name = "${var.name}-check-0"

  tcp_health_check {
    port = var.health_check_port
  }
}
resource "google_compute_region_backend_service" "main" {
  health_checks = [google_compute_health_check.main.self_link]
  count         = length(var.backends)
  name          = "${var.name}-${count.index}"

  dynamic "backend" {
    for_each = var.backends[count.index]
    content {
      group    = lookup(backend.value, "group")
      failover = lookup(backend.value, "failover")
    }
  }
  session_affinity = "NONE"
}

resource "google_compute_forwarding_rule" "main" {
  count                 = length(var.backends)
  name                  = "${var.name}-all-${count.index}"
  load_balancing_scheme = "INTERNAL"
  ip_protocol           = "TCP"
  all_ports             = true
  subnetwork            = var.subnetworks[0]
  backend_service       = google_compute_region_backend_service.main[count.index].self_link
}
