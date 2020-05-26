terraform {
  required_version = ">= 0.12"
}

provider "google" {
  credentials = var.auth_file
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  version     = "> 2.50.0"
}

data "google_compute_zones" "available" {}