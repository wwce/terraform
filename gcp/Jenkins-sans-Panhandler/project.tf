resource "random_pet" "pet_name" {}

resource "google_project" "blue_team_project" {
  name                = "${var.Blue_Team_Name}-${random_pet.pet_name.id}"
  project_id          = "${var.Blue_Team_Name}-${random_pet.pet_name.id}"
  billing_account     = var.Billing_Account
  auto_create_network = false
}

resource "google_project_service" "blue_team_project" {
  project                    = google_project.blue_team_project.project_id
  service                    = "storage-api.googleapis.com"
  disable_dependent_services = true
}

resource "google_compute_project_metadata" "blue_team_ssh_key" {
  project                    = google_project.blue_team_project.project_id
  metadata = {
    ssh-keys = fileexists(var.Public_Key_File) ? "ubuntu:${file(var.Public_Key_File)}" : "" 
  }
}

resource "google_project" "red_team_project" {
  name                = "${var.Red_Team_Name}-${random_pet.pet_name.id}"
  project_id          = "${var.Red_Team_Name}-${random_pet.pet_name.id}"
  billing_account     = var.Billing_Account
  auto_create_network = false
}

resource "google_project_service" "red_team_project" {
  project                    = google_project.red_team_project.project_id
  service                    = "storage-api.googleapis.com"
  disable_dependent_services = true
}

resource "google_compute_project_metadata" "red_team_ssh_key" {
  project                    = google_project.red_team_project.project_id
  metadata = {
    ssh-keys = fileexists(var.Public_Key_File) ? "ubuntu:${file(var.Public_Key_File)}" : ""
  }
}