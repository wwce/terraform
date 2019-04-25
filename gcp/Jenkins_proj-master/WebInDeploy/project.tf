resource "random_id" "project_number" {
  byte_length = 2
}
resource "google_project" "victim_project" {
  name = "${var.Victim_Project_Name}-${random_id.project_number.hex}"
  project_id = "${var.Victim_Project_Name}-${random_id.project_number.hex}"
  billing_account = "${var.Billing_Account}"
  auto_create_network = false
}
resource "google_project_service" "victim_project" {
  project                    = "${google_project.victim_project.project_id}",
  service                    = "storage-api.googleapis.com"
  disable_dependent_services = true
}
resource "google_project" "attacker_project" {
  name = "${var.Attacker_Project_Name}-${random_id.project_number.hex}"
  project_id = "${var.Attacker_Project_Name}-${random_id.project_number.hex}"
  billing_account = "${var.Billing_Account}"
  auto_create_network = false
}
resource "google_project_service" "attacker_project" {
  project                    = "${google_project.attacker_project.project_id}",
  service                    = "storage-api.googleapis.com"
  disable_dependent_services = true
}