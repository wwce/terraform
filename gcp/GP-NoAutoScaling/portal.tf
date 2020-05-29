resource "google_compute_address" "gp_portal_management" {
  name   = "gp-portal-management"
  project = google_project.globalprotect.number
  region  = var.GCP_Region
}

resource "google_compute_address" "gp_portal_untrust" {
  name   = "gp-portal-untrust"
  project = google_project.globalprotect.number
  region  = var.GCP_Region
}

resource "google_compute_instance" "portal" {
  project                   = google_project.globalprotect.number
  name                      = "gp-portal"
  machine_type              = var.FW_Machine_Type
  zone                      = data.google_compute_zones.available.names[0]
  can_ip_forward            = false
  allow_stopping_for_update = true
  metadata = {
    vmseries-bootstrap-gce-storagebucket = google_storage_bucket.portal_bucket.name
    serial-port-enable      = true
    ssh-keys                = fileexists(var.Public_Key_Path) ? "admin:${file(var.Public_Key_Path)}" : ""
  }
  
  service_account {
    scopes = [
      "https://www.googleapis.com/auth/compute.readonly",
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
    ]
  }
  
  network_interface {
    subnetwork    = google_compute_subnetwork.untrust_subnet.self_link
    access_config {
      nat_ip = google_compute_address.gp_portal_untrust.address
    }
  }

  network_interface {
    subnetwork    = google_compute_subnetwork.management_subnet.self_link
    access_config {
      nat_ip = google_compute_address.gp_portal_management.address
    }
  }

  boot_disk {
    initialize_params {
      image = "${var.FW_Image}-${var.FW_PanOS}"
      type  = "pd-ssd"
    }
  }
}
