resource "google_compute_instance" "firewall" {
  project                   = "${google_project.victim_project.id}"
  name                      = "firewall"
  machine_type              = "n1-standard-4"
  zone                      = "${var.GCP_Zone}"
  min_cpu_platform          = "Intel Skylake"
  can_ip_forward            = true
  allow_stopping_for_update = true
  timeouts = {
    create = "15m"
    delete = "60m"
  }
  depends_on = ["google_storage_bucket_object.init_cfg",
                "google_storage_bucket_object.bootstrap",
                "google_storage_bucket_object.content",
                "google_storage_bucket_object.software",
                "google_storage_bucket_object.license",
                "google_project_service.victim_project"
  ]
  // Adding METADATA Key Value pairs to VM-Series GCE instance
  metadata {
    vmseries-bootstrap-gce-storagebucket = "${google_storage_bucket.bootstrap_bucket.name}"
    serial-port-enable                   = true
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
    ]
  }

  network_interface {
    subnetwork    = "${google_compute_subnetwork.untrust_subnet.self_link}"
    network_ip    = "${var.FW_Untrust_IP}"
    access_config = {}
  }

  network_interface {
    subnetwork    = "${google_compute_subnetwork.management_subnet.self_link}"
    network_ip    = "${var.FW_Mgmt_IP}"
    access_config = {}
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.trust_subnet.self_link}"
    network_ip    = "${var.FW_Trust_IP}"
  }

  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-bundle2-814"
    }
  }
}
