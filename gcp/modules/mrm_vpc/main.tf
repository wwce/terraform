variable vpc_name {}

variable subnetworks {
  type = "list"
}

variable ip_cidrs {
  type = "list"
}

variable regions {
  type = "list"
}

variable ingress_allow_all {
  default = true
}

variable ingress_sources {
  type    = "list"
  default = ["0.0.0.0/0"]
}

resource "google_compute_network" "default" {
  name                    = "${var.vpc_name}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  count         = "${length(var.subnetworks)}"
  name          = "${element(var.subnetworks, count.index)}"
  ip_cidr_range = "${element(var.ip_cidrs, count.index)}"
  region        = "${element(var.regions, count.index)}"
  network       = "${google_compute_network.default.self_link}"
}

resource "google_compute_firewall" "ingress_all" {
  count         = "${var.ingress_allow_all}"
  name          = "${google_compute_network.default.name}-ingress-all"
  network       = "${google_compute_network.default.self_link}"
  direction     = "INGRESS"
  source_ranges = "${var.ingress_sources}"

  allow {
    protocol = "all"
  }
}

output "subnetwork_id" {
  value = "${google_compute_subnetwork.default.*.id}"
}

output "subnetwork_name" {
  value = "${google_compute_subnetwork.default.*.name}"
}

output "subnetwork_self_link" {
  value = "${google_compute_subnetwork.default.*.self_link}"
}

output "vpc_name" {
  value = "${google_compute_network.default.*.name}"
}

output "vpc_id" {
  value = "${google_compute_network.default.*.id[0]}"
}

output "vpc_self_link" {
  value = "${google_compute_network.default.*.self_link[0]}"
}
