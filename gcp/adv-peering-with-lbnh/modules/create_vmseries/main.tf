variable fw_subnetworks {
  type = "list"
}

variable fw_names {
  type = "list"
}

variable fw_machine_type {}

variable fw_zones {
  type = "list"
}

variable fw_cpu_platform {
  default = "Intel Skylake"
}

variable fw_bootstrap_bucket {
  default = ""
}

variable fw_ssh_key {}

variable public_lb_create {
  default = false
}

variable fw_scopes {
  type = "list"

  default = [
    "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
  ]
}

variable fw_image {}

variable fw_tags {
  type    = "list"
  default = []
}

variable create_instance_group {
  default = false
}

variable instance_group_names {
  type    = "list"
  default = ["vmseries-instance-group"]
}

variable "dependencies" {
  type    = "list"
  default = []
}

variable fw_nic0_ip {
  type    = "list"
  default = []
}

variable fw_nic1_ip {
  type    = "list"
  default = []
}

variable fw_nic2_ip {
  type    = "list"
  default = []
}

resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

#************************************************************************************
# CREATE VMSERIES 
#***********************************************************************************
resource "google_compute_instance" "vmseries" {
  count                     = "${length(var.fw_names)}"
  name                      = "${element(var.fw_names, count.index)}"
  machine_type              = "${var.fw_machine_type}"
  zone                      = "${element(var.fw_zones, count.index)}"
  min_cpu_platform          = "${var.fw_cpu_platform}"
  can_ip_forward            = true
  allow_stopping_for_update = true
  tags                      = "${var.fw_tags}"

  metadata {
    vmseries-bootstrap-gce-storagebucket = "${var.fw_bootstrap_bucket}"
    serial-port-enable                   = true
    sshKeys                              = "${var.fw_ssh_key}"
  }

  service_account {
    scopes = "${var.fw_scopes}"
  }

  network_interface {
    subnetwork    = "${var.fw_subnetworks[0]}"
    access_config = {}
    network_ip    = "${element(var.fw_nic0_ip, count.index)}"
  }

  network_interface {
    subnetwork    = "${var.fw_subnetworks[1]}"
    access_config = {}
    network_ip    = "${element(var.fw_nic1_ip, count.index)}"
  }

  network_interface {
    subnetwork = "${var.fw_subnetworks[2]}"
    network_ip = "${element(var.fw_nic2_ip, count.index)}"
  }

  boot_disk {
    initialize_params {
      image = "${var.fw_image}"
    }
  }

  depends_on = [
    "null_resource.dependency_getter",
  ]
}

#************************************************************************************
# CREATE INSTANCE GROUP
#************************************************************************************
resource "google_compute_instance_group" "vmseries" {
  count     = "${(var.create_instance_group) ? length(var.fw_names) : 0}"
  name      = "${element(var.instance_group_names, count.index)}"
  zone      = "${element(var.fw_zones, count.index)}"
  instances = ["${google_compute_instance.vmseries.*.self_link[count.index]}"]

  named_port {
    name = "http"
    port = "80"
  }
}






#************************************************************************************
# OUTPUTS
#************************************************************************************

output "fw_names" {
  value = "${google_compute_instance.vmseries.*.name}"
}

output "fw_self_link" {
  value = "${google_compute_instance.vmseries.*.self_link}"
}

output "instance_group" {
  value = "${google_compute_instance_group.vmseries.*.self_link}"
}


output "fw_nic0_public_ip" {
  value = "${google_compute_instance.vmseries.*.network_interface.0.access_config.0.nat_ip}"
}

output "fw_nic1_public_ip" {
  value = "${google_compute_instance.vmseries.*.network_interface.1.access_config.0.nat_ip}"
}