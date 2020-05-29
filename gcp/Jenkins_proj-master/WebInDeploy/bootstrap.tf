resource "google_storage_bucket" "bootstrap_bucket" {
  name            = "${var.Victim_Project_Name}-${random_id.project_number.hex}"
  storage_class   = "REGIONAL"
  location        = "${var.GCP_Region}"
  project         = "${google_project.victim_project.id}"
} 
resource "google_storage_bucket" "attacker_bucket" {
  name            = "${var.Attacker_Project_Name}-${random_id.project_number.hex}"
  storage_class   = "REGIONAL"
  location        = "${var.GCP_Region}"
  project         = "${google_project.attacker_project.id}"
} 
resource "google_storage_bucket_object" "config_file_webserver" {
  name   = "initialize_webserver.sh"
  source = "scripts/initialize_webserver.sh"
  bucket = "${google_storage_bucket.bootstrap_bucket.name}"
}
resource "google_storage_bucket_object" "config_file_attacker" {
  name   = "initialize_attacker.sh"
  source = "scripts/initialize_attacker.sh"
  bucket = "${google_storage_bucket.attacker_bucket.name}"
}
resource "google_storage_bucket_object" "bootstrap" {
  name   = "config/bootstrap.xml"
  source = "bootstrap/bootstrap.xml"
  bucket = "${google_storage_bucket.bootstrap_bucket.name}"
}
resource "google_storage_bucket_object" "init_cfg" {
  name   = "config/init-cfg.txt"
  source = "bootstrap/init-cfg.txt"
  bucket = "${google_storage_bucket.bootstrap_bucket.name}"
}
resource "google_storage_bucket_object" "content" {
  name   = "content/null.txt"
  source = "bootstrap/null.txt"
  bucket = "${google_storage_bucket.bootstrap_bucket.name}"
}
resource "google_storage_bucket_object" "software" {
  name   = "software/null.txt"
  source = "bootstrap/null.txt"
  bucket = "${google_storage_bucket.bootstrap_bucket.name}"
}
resource "google_storage_bucket_object" "license" {
  name   = "license/null.txt"
  source = "bootstrap/null.txt"
  bucket = "${google_storage_bucket.bootstrap_bucket.name}"
}