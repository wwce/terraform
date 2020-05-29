resource "google_compute_firewall" "management" {
  name    = "management-firewall"
  project = "${google_project.victim_project.id}"
  network = "${google_compute_network.management_network.name}"
  allow {
    protocol = "tcp"
    ports    = ["22", "443"]
  }
}
resource "google_compute_firewall" "untrust" {
  name    = "untrust-firewall"
  project = "${google_project.victim_project.id}"
  network = "${google_compute_network.untrust_network.name}"
  allow {
    protocol = "tcp"
  }
}
resource "google_compute_firewall" "trust" {
  name    = "trust-firewall"
  project = "${google_project.victim_project.id}"
  network = "${google_compute_network.trust_network.name}"
  allow {
    protocol = "tcp"
  }
}
resource "google_compute_firewall" "attacker" {
  name    = "attacker-firewall"
  project = "${google_project.attacker_project.id}"
  network = "${google_compute_network.attacker_network.name}"
  allow {
    protocol = "tcp"
    ports    = ["22", "443", "5000"]
  }
}
