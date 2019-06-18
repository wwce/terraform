resource "google_compute_instance" "attacker" {
  name         = "attacker"
  project      = "${google_project.attacker_project.id}"
  zone         = "${var.GCP_Zone}"
  machine_type = "n1-standard-1"
  allow_stopping_for_update = true
  timeouts = {
    create = "15m"
    delete = "60m"
  }
  depends_on = [
                "google_storage_bucket_object.config_file_attacker",
                "google_project_service.attacker_project"
  ]
  metadata {
    startup-script-url      = "gs://${google_storage_bucket.attacker_bucket.name}/initialize_attacker.sh"
    serial-port-enable  = true
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
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }

  network_interface {
    subnetwork    = "${google_compute_subnetwork.attacker_subnet.self_link}"
    network_ip    = "${var.Attacker_IP}"
    access_config = {}
  }
  depends_on = ["google_storage_bucket_object.config_file_attacker"]
}
