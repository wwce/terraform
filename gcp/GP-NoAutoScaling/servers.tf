resource "google_compute_instance" "server1" {
  name         = "server1"
  project      = google_project.globalprotect.number
  zone         = data.google_compute_zones.available.names[0]
  machine_type = "n1-standard-1"
  allow_stopping_for_update = true
  timeouts = {
    create = "15m"
    delete = "60m"
  }

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

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }

  network_interface {
    subnetwork    = google_compute_subnetwork.management_subnet.self_link
    access_config {}
  }
}

rresource "google_compute_instance" "server2" {
  name         = "server2"
  project      = google_project.globalprotect.number
  zone         = data.google_compute_zones.available.names[1]
  machine_type = "n1-standard-1"
  allow_stopping_for_update = true
  timeouts = {
    create = "15m"
    delete = "60m"
  }

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

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }

  network_interface {
    subnetwork    = google_compute_subnetwork.management_subnet.self_link
    access_config {}
  }
}