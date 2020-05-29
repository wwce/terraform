resource "random_id" "random_number" {
  byte_length = 2
}
resource "google_project" "globalprotect" {
  name                = "${var.Base_Project_Name}-${random_id.random_number.hex}"
  project_id          = "${var.Base_Project_Name}-${random_id.random_number.hex}"
  billing_account     = var.Billing_Account
  auto_create_network = false
}
resource "google_project_service" "globalprotect" {
  project                    = google_project.globalprotect.number
  service                    = "storage-api.googleapis.com"
  disable_dependent_services = true
}

data "google_compute_zones" "available" {
  project = google_project.globalprotect.project_id
  region  = var.GCP_Region
}