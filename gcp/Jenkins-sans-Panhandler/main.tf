provider "google" {
  region = var.GCP_Region
  version     = "3.13.0"
}

provider "google-beta" {
  version     = "3.13.0"
}

provider "random" {
}