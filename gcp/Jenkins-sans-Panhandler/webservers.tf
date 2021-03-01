resource "google_compute_instance" "webserver" {
  name                      = "webserver"
  project                   = google_project.blue_team_project.project_id
  zone                      = var.GCP_Zone
  machine_type              = "n1-standard-1"
  allow_stopping_for_update = true
  timeouts {
    create = "15m"
    delete = "60m"
  }
  depends_on = [
    google_storage_bucket_object.config_file_webserver,
    google_project_service.blue_team_project,
  ]
  metadata = {
    startup-script-url = "gs://${google_storage_bucket.bootstrap_bucket.name}/initialize_server.sh"
    serial-port-enable = true
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/compute.readonly",
    ]
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.trust_subnet.self_link
    network_ip = var.Webserver_IP1
    access_config {
    }
  }
}