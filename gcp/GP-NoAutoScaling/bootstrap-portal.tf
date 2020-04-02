resource "google_storage_bucket" "portal_bucket" {
  name            = "portal-${random_id.random_number.hex}"
  storage_class   = "REGIONAL"
  location        = var.GCP_Region
  project         = google_project.globalprotect.number
} 
resource "google_storage_bucket_object" "portal_bootstrap" {
  name   = "config/bootstrap.xml"
  source = "bootstrap-portal/bootstrap.xml"
  bucket = google_storage_bucket.portal_bucket.name
}
resource "google_storage_bucket_object" "portal_init_cfg" {
  name   = "config/init-cfg.txt"
  source = "bootstrap-portal/init-cfg.txt"
  bucket = google_storage_bucket.portal_bucket.name
}
resource "google_storage_bucket_object" "portal_content" {
  name   = "content/null.txt"
  source = "bootstrap-portal/null.txt"
  bucket = google_storage_bucket.portal_bucket.name
}
resource "google_storage_bucket_object" "portal_software" {
  name   = "software/null.txt"
  source = "bootstrap-portal/null.txt"
  bucket = google_storage_bucket.portal_bucket.name
}
resource "google_storage_bucket_object" "portal_license" {
  name   = "license/null.txt"
  source = "bootstrap-portal/null.txt"
  bucket = google_storage_bucket.portal_bucket.name
}