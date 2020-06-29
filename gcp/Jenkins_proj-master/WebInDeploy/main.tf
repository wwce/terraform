provider "google" {
  credentials = "${file("/root/.config/gcloud/application_default_credentials.json")}"
  region = "${var.GCP_Region}"
}

provider "random" {}
