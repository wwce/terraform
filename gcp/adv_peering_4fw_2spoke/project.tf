terraform {
  required_version = ">= 0.12"
}

provider "google" {
 # credentials = var.auth_file
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
 # credentials = var.auth_file
  project     = var.project_id
  region      = var.region
  version     = "> 2.13.0"
}

data "google_compute_zones" "available" {}