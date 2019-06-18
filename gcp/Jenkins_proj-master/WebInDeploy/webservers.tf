resource "google_compute_instance" "jenkins1" {
  name         = "jenkins1"
  project      = "${google_project.victim_project.id}"
  zone         = "${var.GCP_Zone}"
  machine_type = "n1-standard-1"
  allow_stopping_for_update = true
  timeouts = {
    create = "15m"
    delete = "60m"
  }
  depends_on = [
                "google_storage_bucket_object.config_file_webserver",
                "google_project_service.victim_project"
  ]
  metadata {
    startup-script-url      = "gs://${google_storage_bucket.bootstrap_bucket.name}/initialize_webserver.sh"
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
    subnetwork    = "${google_compute_subnetwork.trust_subnet.self_link}"
    network_ip    = "${var.Webserver_IP1}"
    access_config = {}
  }
  depends_on = ["google_storage_bucket_object.config_file_webserver"]
}
resource "google_compute_instance" "jenkins2" {
  name         = "jenkins2"
  project      = "${google_project.victim_project.id}"
  zone         = "${var.GCP_Zone}"
  machine_type = "n1-standard-1"
  allow_stopping_for_update = true
  depends_on = [
                "google_storage_bucket_object.config_file_webserver",
                "google_project_service.victim_project"
  ]
  metadata {
    startup-script-url      = "gs://${google_storage_bucket.bootstrap_bucket.name}/initialize_webserver.sh"
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
    subnetwork    = "${google_compute_subnetwork.trust_subnet.self_link}"
    network_ip    = "${var.Webserver_IP2}"
    access_config = {}
  }
  depends_on = ["google_storage_bucket_object.config_file_webserver"]
}
