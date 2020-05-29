resource "google_compute_network" "default" {
  name                            = var.vpc
  delete_default_routes_on_create = var.delete_default_route
  auto_create_subnetworks         = false
}

resource "google_compute_subnetwork" "default" {
  count         = length(var.subnets)
  name          = element(var.subnets, count.index)
  ip_cidr_range = element(var.cidrs, count.index)
  region        = element(var.regions, count.index)
  network       = google_compute_network.default.self_link
}

resource "google_compute_firewall" "default" {
  count         = length(var.allowed_sources) != 0 ? 1 : 0
  name          = "${google_compute_network.default.name}-ingress"
  network       = google_compute_network.default.self_link
  direction     = "INGRESS"
  source_ranges = var.allowed_sources

  allow {
    protocol = var.allowed_protocol
    ports    = var.allowed_ports
  }
}

