resource "google_storage_bucket" "gateway_bucket" {
  name            = "gateway-${random_id.random_number.hex}"
  storage_class   = "REGIONAL"
  location        = var.GCP_Region
  project         = google_project.globalprotect.number
} 
resource "google_storage_bucket_object" "gateway_bootstrap" {
  name   = "config/bootstrap.xml"
  source = "bootstrap-gateway/bootstrap.xml"
  bucket = google_storage_bucket.gateway_bucket.name
}
resource "google_storage_bucket_object" "gateway_init_cfg" {
  name   = "config/init-cfg.txt"
  source = "bootstrap-gateway/init-cfg.txt"
  bucket = google_storage_bucket.gateway_bucket.name
}
resource "google_storage_bucket_object" "gateway_content" {
  name   = "content/null.txt"
  source = "bootstrap-gateway/null.txt"
  bucket = google_storage_bucket.gateway_bucket.name
}
resource "google_storage_bucket_object" "gateway_software" {
  name   = "software/null.txt"
  source = "bootstrap-gateway/null.txt"
  bucket = google_storage_bucket.gateway_bucket.name
}
resource "google_storage_bucket_object" "gateway_license" {
  name   = "license/null.txt"
  source = "bootstrap-gateway/null.txt"
  bucket = google_storage_bucket.gateway_bucket.name
}