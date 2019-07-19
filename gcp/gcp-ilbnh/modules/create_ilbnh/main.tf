variable enable_ilbnh {
  default = false
}
variable "internal_lb_name_ilbnh" {
  default = "ilbnh"
}
variable "internal_lb_ports_ilbnh" {
  default = "22"
}
variable backends {
  description = "Map backend indices to list of backend maps."
  type        = "list"
}
variable subnetworks {
    type = "list"
}
variable "internal_lbnh_ip" {
  default = ""
}
#************************************************************************************
# CREATE VMSERIES INTERNAL LOAD BALANCER - ILBNH
#************************************************************************************
resource "google_compute_health_check" "health_check_ilbnh" {
  name  = "${var.internal_lb_name_ilbnh}-check"
  count = "${var.enable_ilbnh ? 1 : 0}"

  tcp_health_check {
    port = "${var.internal_lb_ports_ilbnh}"
  }
}

resource "google_compute_region_backend_service" "backend_service_ilbnh" {
  name              = "${var.internal_lb_name_ilbnh}"
  count             = "${var.enable_ilbnh ? 1 : 0}"
  health_checks     = ["${google_compute_health_check.health_check_ilbnh.self_link}"]
  backend           = ["${var.backends}"] 
  session_affinity  = "CLIENT_IP"

}


resource "google_compute_forwarding_rule" "forwarding_rule_ilbnh" {
  name                  = "${var.internal_lb_name_ilbnh}-all"
  count                 = "${var.enable_ilbnh ? 1 : 0}"
  load_balancing_scheme = "INTERNAL"
  ip_address            = "${var.internal_lbnh_ip}"
  ip_protocol           = "TCP"
  all_ports             = true
  subnetwork            = "${var.subnetworks[0]}"
  backend_service       = "${google_compute_region_backend_service.backend_service_ilbnh.self_link}"
}