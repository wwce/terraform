#-----------------------------------------------------------------------------------------------
# Create the internal load balancers, one for the testing network and one for the production network.
# This resource will destroy (potentially immediately) after null_resource.next
resource "google_compute_region_backend_service" "default" {
  provider              = "google-beta"
  name                  = var.name
  project               = var.project_id
  load_balancing_scheme = "INTERNAL"
  health_checks         = var.health_checks
  region                = var.region
  network               = var.network_uri

  backend {
    group               = var.group
  }
}

resource "google_compute_forwarding_rule" "default" {
  name                  = "fr-${var.name}"
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.default.id
  all_ports             = var.all_ports
  network               = var.network
  subnetwork            = var.subnetwork
  ip_address            = var.ip_address
}