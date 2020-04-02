resource "google_compute_firewall" "management" {
  name    = "management-firewall"
  project = google_project.globalprotect.number
  network = google_compute_network.management_network.name
  allow {
    protocol = "tcp"
    ports    = ["22", "443"]
  }
}
resource "google_compute_firewall" "untrust" {
  name    = "untrust-firewall"
  project = google_project.globalprotect.number
  network = google_compute_network.untrust_network.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  allow {
    protocol = "udp"
    ports    = ["500","4500","4501"]
  }
  allow {
    protocol = "esp"
  }
}
resource "google_compute_firewall" "trust" {
  name    = "trust-firewall"
  project = google_project.globalprotect.number
  network = google_compute_network.trust_network.name
  allow {
    protocol = "all"
  }
}