provider "google" {
  credentials = "${file(var.credentials_file_path)}"
  project     = "${var.my_gcp_project}"
  region      = "${var.region}"
}

// Adding SSH Public Key Project Wide
resource "google_compute_project_metadata_item" "ssh-keys" {
  key   = "ssh-keys"
  value = "${var.gce_ssh_user}:${var.gce_ssh_pub_key}"
}

// Adding VPC Networks to Project  MANAGEMENT
resource "google_compute_subnetwork" "management-sub" {
  name          = "management-sub"
  ip_cidr_range = "10.5.0.0/24"
  network       = "${google_compute_network.management.self_link}"
  region        = "${var.region}"
}

resource "google_compute_network" "management" {
  name                    = "${var.interface_0_name}"
  auto_create_subnetworks = "false"
}

// Adding VPC Networks to Project  UNTRUST
resource "google_compute_subnetwork" "untrust-sub" {
  name          = "untrust-sub"
  ip_cidr_range = "10.5.1.0/24"
  network       = "${google_compute_network.untrust.self_link}"
  region        = "${var.region}"
}

resource "google_compute_network" "untrust" {
  name                    = "${var.interface_1_name}"
  auto_create_subnetworks = "false"
}

// Adding VPC Networks to Project  TRUST
resource "google_compute_subnetwork" "trust-sub" {
  name          = "trust-sub"
  ip_cidr_range = "10.5.2.0/24"
  network       = "${google_compute_network.trust.self_link}"
  region        = "${var.region}"
}

resource "google_compute_network" "trust" {
  name                    = "${var.interface_2_name}"
  auto_create_subnetworks = "false"
}

// Adding GCP Outbound Route to TRUST Interface
resource "google_compute_route" "trust" {
  name                   = "trust-route"
  dest_range             = "0.0.0.0/0"
  network                = "${google_compute_network.trust.self_link}"
  next_hop_instance      = "${element(google_compute_instance.firewall.*.name,count.index)}"
  next_hop_instance_zone = "${var.zone}"
  priority               = 100

  depends_on = ["google_compute_instance.firewall",
    "google_compute_network.trust",
    "google_compute_network.untrust",
    "google_compute_network.management",
    "google_container_cluster.cluster",
    "google_compute_instance.firewall",
    "google_container_node_pool.db_nodes",
  ]
}

// Adding GCP Route to Cluster MGMT Endpoint
resource "google_compute_route" "k8mgmt" {
  name             = "cluster-endpoint-route"
  dest_range       = "${element(google_container_cluster.cluster.*.endpoint,count.index)}/32"
  network          = "${google_compute_network.trust.self_link}"
  next_hop_gateway = "default-internet-gateway"
  priority         = 100

  depends_on = ["google_compute_instance.firewall",
    "google_compute_network.trust",
    "google_compute_network.untrust",
    "google_compute_network.management",
    "google_container_cluster.cluster",
    "google_compute_instance.firewall",
    "google_container_node_pool.db_nodes",
  ]
}

// Adding GCP Firewall Rules for MANGEMENT
resource "google_compute_firewall" "allow-mgmt" {
  name    = "allow-mgmt"
  network = "${google_compute_network.management.self_link}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["443", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

// Adding GCP Firewall Rules for INBOUND
resource "google_compute_firewall" "allow-inbound" {
  name    = "allow-inbound"
  network = "${google_compute_network.untrust.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["80", "22", "8888"]
  }

  source_ranges = ["0.0.0.0/0"]
}

// Adding GCP Firewall Rules for OUTBOUND
resource "google_compute_firewall" "allow-outbound" {
  name    = "allow-outbound"
  network = "${google_compute_network.trust.self_link}"

  allow {
    protocol = "all"

    # ports    = ["all"]
  }

  source_ranges = ["0.0.0.0/0"]
}

// Create a new Palo Alto Networks NGFW VM-Series GCE instance
resource "google_compute_instance" "firewall" {
  name                      = "${var.firewall_name}-${count.index + 1}"
  machine_type              = "${var.machine_type_fw}"
  zone                      = "${var.zone}"
  can_ip_forward            = true
  allow_stopping_for_update = true
  count                     = 1

  // Adding METADATA Key Value pairs to VM-Series GCE instance
  metadata {
    vmseries-bootstrap-gce-storagebucket = "${var.bootstrap_bucket_fw}"
    serial-port-enable                   = true

    #sshKeys                              = "${var.public_key}"
  }

  service_account {
    scopes = "${var.scopes_fw}"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.management-sub.self_link}"
    network_ip = "10.5.0.4"

    //address       = "10.5.0.4"
    access_config = {}
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.untrust-sub.self_link}"

    network_ip    = "10.5.1.4"
    access_config = {}
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.trust-sub.self_link}"

    network_ip = "10.5.2.100"
  }

  boot_disk {
    initialize_params {
      image = "${var.image_fw}"
    }
  }

  depends_on = [
    "google_compute_network.trust",
    "google_compute_subnetwork.trust-sub",
  ]
}

//Create a K8s cluster
resource "google_container_cluster" "cluster" {
  name                    = "cluster-1"
  zone                    = "${var.zone}"
  min_master_version      = "${var.container-ver}"
  initial_node_count      = 2
  enable_kubernetes_alpha = true
  cluster_ipv4_cidr       = "10.16.0.0/14"
  logging_service         = "none"
  monitoring_service      = "none"
  network                 = "${google_compute_network.trust.self_link}"
  subnetwork              = "${google_compute_subnetwork.trust-sub.self_link}"

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  node_config {
    disk_size_gb = "32"
    image_type   = "COS"
    machine_type = "n1-standard-1"
    preemptible  = false
    oauth_scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/trace.append"]

    labels {
      pool    = "web-pool"
      cluster = "the-cluster"
    }

    tags = ["the-cluster", "gke-node", "web-tier"]
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    "google_compute_network.trust",
    "google_compute_subnetwork.trust-sub",
    "google_compute_instance.firewall",
  ]
}

resource "google_container_node_pool" "db_nodes" {
  name       = "db-node-pool"
  region     = "${var.zone}"
  cluster    = "${google_container_cluster.cluster.name}"
  node_count = 2

  node_config {
    disk_size_gb = "32"
    image_type   = "COS"
    machine_type = "n1-standard-1"
    preemptible  = false
    oauth_scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/trace.append"]

    labels {
      pool    = "db-pool"
      cluster = "the-cluster"
    }

    tags = ["the-cluster", "gke-node", "db-tier"]
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    "google_compute_network.trust",
    "google_compute_subnetwork.trust-sub",
    "google_compute_instance.firewall",
    "google_container_cluster.cluster",
  ]
}

// Adding GCP Route to Node instances
resource "google_compute_route" "gke-node0" {
  name                   = "gke-node0"
  dest_range             = "10.16.0.0/24"
  network                = "${google_compute_network.trust.self_link}"
  next_hop_instance      = "${element(google_compute_instance.firewall.*.name,count.index)}"
  next_hop_instance_zone = "${var.zone}"
  priority               = 10
  tags                   = ["db-tier"]

  depends_on = ["google_compute_instance.firewall",
    "google_compute_network.trust",
    "google_compute_network.untrust",
    "google_compute_network.management",
    "google_container_cluster.cluster",
  ]
}

resource "google_compute_route" "gke-node1" {
  name                   = "gke-node1"
  dest_range             = "10.16.1.0/24"
  network                = "${google_compute_network.trust.self_link}"
  next_hop_instance      = "${element(google_compute_instance.firewall.*.name,count.index)}"
  next_hop_instance_zone = "${var.zone}"
  priority               = 10
  tags                   = ["db-tier"]

  depends_on = ["google_compute_instance.firewall",
    "google_compute_network.trust",
    "google_compute_network.untrust",
    "google_compute_network.management",
    "google_container_cluster.cluster",
  ]
}

resource "google_compute_route" "gke-node2" {
  name                   = "gke-node2"
  dest_range             = "10.16.2.0/24"
  network                = "${google_compute_network.trust.self_link}"
  next_hop_instance      = "${element(google_compute_instance.firewall.*.name,count.index)}"
  next_hop_instance_zone = "${var.zone}"
  priority               = 10
  tags                   = ["web-tier"]

  depends_on = ["google_compute_instance.firewall",
    "google_compute_network.trust",
    "google_compute_network.untrust",
    "google_compute_network.management",
    "google_container_cluster.cluster",
  ]
}

resource "google_compute_route" "gke-node3" {
  name                   = "gke-node3"
  dest_range             = "10.16.3.0/24"
  network                = "${google_compute_network.trust.self_link}"
  next_hop_instance      = "${element(google_compute_instance.firewall.*.name,count.index)}"
  next_hop_instance_zone = "${var.zone}"
  priority               = 10
  tags                   = ["web-tier"]

  depends_on = ["google_compute_instance.firewall",
    "google_compute_network.trust",
    "google_compute_network.untrust",
    "google_compute_network.management",
    "google_container_cluster.cluster",
  ]
}

output "pan-tf-name" {
  value = "${google_compute_instance.firewall.*.name}"
}

output "k8s-cluster-name" {
  value = "${google_container_cluster.cluster.*.name}"
}

output "k8s-cluster-endpoint" {
  value = "${google_container_cluster.cluster.*.endpoint}"
}

output "k8s-cluster_ipv4_cidr" {
  value = "${google_container_cluster.cluster.*.cluster_ipv4_cidr}"
}
