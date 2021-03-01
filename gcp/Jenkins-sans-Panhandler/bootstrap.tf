resource "google_storage_bucket" "bootstrap_bucket" {
  name            = "${var.Blue_Team_Name}-${random_pet.pet_name.id}"
  storage_class   = "REGIONAL"
  location        = var.GCP_Region
  project         = google_project.blue_team_project.project_id
  force_destroy = true
} 
resource "google_storage_bucket" "attacker_bucket" {
  name            = "${var.Red_Team_Name}-${random_pet.pet_name.id}"
  storage_class   = "REGIONAL"
  location        = var.GCP_Region
  project         = google_project.red_team_project.project_id
  force_destroy = true
} 
resource "google_storage_bucket_object" "config_file_webserver" {
  name   = "initialize_server.sh"
  source = var.Server_Initscript_Path
  bucket = google_storage_bucket.bootstrap_bucket.name
}
resource "google_storage_bucket_object" "config_file_attacker" {
  name   = "initialize_attacker.sh"
  source = var.Attacker_Initscript_Path
  bucket = google_storage_bucket.attacker_bucket.name
}
resource "google_storage_bucket_object" "bootstrap" {
  name   = "config/bootstrap.xml"
  source = "bootstrap/bootstrap.xml"
  bucket = google_storage_bucket.bootstrap_bucket.name
}
resource "google_storage_bucket_object" "init_cfg" {
  name   = "config/init-cfg.txt"
  source = "bootstrap/init-cfg.txt"
  bucket = google_storage_bucket.bootstrap_bucket.name
}
#resource "google_storage_bucket_object" "content" {
#  name   = "content/null.txt"
#  source = "bootstrap/null.txt"
#  bucket = google_storage_bucket.bootstrap_bucket.name
#}
resource "google_storage_bucket_object" "software" {
  name   = "software/null.txt"
  source = "bootstrap/null.txt"
  bucket = google_storage_bucket.bootstrap_bucket.name
}
resource "google_storage_bucket_object" "license" {
  name   = "license/null.txt"
  source = "bootstrap/null.txt"
  bucket = google_storage_bucket.bootstrap_bucket.name
}
resource "google_storage_bucket_object" "content" {
  name = "content/"
  source = "/dev/null"
  bucket = google_storage_bucket.bootstrap_bucket.name
}

resource "null_resource" "populate_content" {
  provisioner "local-exec" {
    command = "gsutil rsync -d -r gs://${var.Content_Bucket}/ gs://${google_storage_bucket.bootstrap_bucket.name}/content/"
  }
  depends_on = [
    google_storage_bucket_object.content,
  ]
}