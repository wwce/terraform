resource "google_compute_network" "management_network" {
  project                 = google_project.blue_team_project.project_id
  name                    = "management"
  auto_create_subnetworks = false
}

resource "google_compute_network" "untrust_network" {
  project                 = google_project.blue_team_project.project_id
  name                    = "untrust"
  auto_create_subnetworks = false
}

resource "google_compute_network" "trust_network" {
  project                 = google_project.blue_team_project.project_id
  name                    = "trust"
  auto_create_subnetworks = false
}

resource "google_compute_network" "attacker_network" {
  project                 = google_project.red_team_project.project_id
  name                    = "attacker"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "management_subnet" {
  name          = "management"
  project       = google_project.blue_team_project.project_id
  region        = var.GCP_Region
  ip_cidr_range = var.Management_Subnet_CIDR
  network       = google_compute_network.management_network.self_link
}

resource "google_compute_subnetwork" "untrust_subnet" {
  name          = "untrust"
  project       = google_project.blue_team_project.project_id
  region        = var.GCP_Region
  ip_cidr_range = var.Untrust_Subnet_CIDR
  network       = google_compute_network.untrust_network.self_link
}

resource "google_compute_subnetwork" "trust_subnet" {
  name          = "trust"
  project       = google_project.blue_team_project.project_id
  region        = var.GCP_Region
  ip_cidr_range = var.Trust_Subnet_CIDR
  network       = google_compute_network.trust_network.self_link
}

resource "google_compute_subnetwork" "attacker_subnet" {
  name          = "attacker"
  project       = google_project.red_team_project.project_id
  region        = var.GCP_Region
  ip_cidr_range = var.Attacker_Subnet_CIDR
  network       = google_compute_network.attacker_network.self_link
}