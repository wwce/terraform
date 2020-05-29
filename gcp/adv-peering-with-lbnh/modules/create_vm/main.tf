variable vm_names {
    type = "list"
}
variable vm_machine_type {}
variable vm_zones {
  type = "list"
}
variable vm_ssh_key {}

variable vm_image {}
variable vm_subnetworks {
    type = "list"
}

variable vm_scopes {
  type = "list"
  default = [
    "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
  ]
}


variable internal_lb_create {
  default = false
}

variable "internal_lb_health_check" {
  default = "22"
}

variable "internal_lb_ports" {
  type    = "list"
  default = ["80"]
}

variable "internal_lb_name" {
  default = "intlb"
}

variable "internal_lb_ip" {
  default = ""
}

variable create_instance_group {
  default = false
}

variable startup_script {
default = ""
}


resource "google_compute_instance" "vm" {
  count         = "${length(var.vm_names)}"
  name          = "${element(var.vm_names, count.index)}"
  machine_type              = "${var.vm_machine_type}"
  zone                      = "${element(var.vm_zones, count.index)}"
  can_ip_forward            = true
  allow_stopping_for_update = true
  metadata_startup_script   = "${var.startup_script}"


  metadata {
    serial-port-enable = true
    sshKeys            = "${var.vm_ssh_key}"
  }

  network_interface {
    subnetwork = "${element(var.vm_subnetworks, count.index)}"
  }

  boot_disk {
    initialize_params {
      image = "${var.vm_image}"
    }
  }

  service_account {
    scopes = "${var.vm_scopes}"
  }
}

resource "google_compute_instance_group" "instance_group" {
  count = "${var.internal_lb_create}"
  name  = "${var.internal_lb_name}-group"
  zone  = "${var.vm_zones[0]}"

  instances = [
    "${google_compute_instance.vm.*.self_link}",
  ]
}




resource "google_compute_health_check" "health_check" {
  count = "${var.internal_lb_create}"
  name  = "${var.internal_lb_name}-check-${count.index}"

  tcp_health_check {
    port = "${var.internal_lb_ports[0]}"
  }
}

resource "google_compute_region_backend_service" "backend_service" {
  count         = "${var.internal_lb_create}"
  name          = "${var.internal_lb_name}-backend-${count.index}"
  health_checks = ["${google_compute_health_check.health_check.self_link}"]

  backend {
    group = "${google_compute_instance_group.instance_group.self_link}"
  }
}


resource "google_compute_forwarding_rule" "forwarding_rule" {
  count                 = "${var.internal_lb_create}"
  name                  = "${var.internal_lb_name}-tcp"
  load_balancing_scheme = "INTERNAL"
  ip_address            = "${var.internal_lb_ip}"
  ports                 = "${var.internal_lb_ports}"
  subnetwork            = "${var.vm_subnetworks[0]}"
  backend_service       = "${google_compute_region_backend_service.backend_service.self_link}"
}