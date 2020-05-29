resource "google_compute_instance_group" "firewalls" {
  name        = "firewalls-instance-group"
  description = "An instance group for the single FW instance"
  project     = "${google_project.victim_project.id}"
  zone        = "${var.GCP_Zone}"

  instances = [
    "${google_compute_instance.firewall.self_link}",
  ]
  named_port {
    name = "http-8080"
    port = "8080"
  }
}
resource "google_compute_target_pool" "firewalls" {
  name    = "armor-pool-firewalls"
  project = "${google_project.victim_project.id}"

  instances = [
    "${google_compute_instance.firewall.self_link}",
  ]

  health_checks = [
    "${google_compute_http_health_check.health.name}",
  ]
}
resource "google_compute_backend_service" "firewalls" {
  name        = "armor-backend-firewalls"
  description = "With FW"
  project     = "${google_project.victim_project.id}"
  port_name   = "http-8080"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = false

  backend {
    group = "${google_compute_instance_group.firewalls.self_link}"
  }

  security_policy = "${google_compute_security_policy.security-policy-firewalls.self_link}"

  health_checks = ["${google_compute_http_health_check.health.self_link}"]
}
resource "google_compute_security_policy" "security-policy-firewalls" {
  name        = "armor-security-policy-firewalls"
  description = "example security policy"
  project     = "${google_project.victim_project.id}"

  # Reject all traffic that hasn't been whitelisted.
  rule {
    action   = "deny(403)"
    priority = "2147483647"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = ["*"]
      }
    }

    description = "Default rule, higher priority overrides it"
  }
  # Whitelist traffic from certain ip address
  rule {
    action   = "allow"
    priority = "1000"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = ["0.0.0.0/0"]
      }
    }
  }
}
resource "google_compute_global_forwarding_rule" "firewalls" {
  name       = "armor-rule-firewalls"
  project    = "${google_project.victim_project.id}"
  target     = "${google_compute_target_http_proxy.firewalls.self_link}"
  port_range = "80"
}
resource "google_compute_target_http_proxy" "firewalls" {
  name    = "armor-proxy-firewalls"
  project = "${google_project.victim_project.id}"
  url_map = "${google_compute_url_map.firewalls.self_link}"
}
resource "google_compute_url_map" "firewalls" {
  name            = "armor-url-map-firewalls"
  project         = "${google_project.victim_project.id}"
  default_service = "${google_compute_backend_service.firewalls.self_link}"

  host_rule {
    hosts        = ["with-firewalls.com"]
    path_matcher = "allpaths"
  }
  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_backend_service.firewalls.self_link}"

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_backend_service.firewalls.self_link}"
    }
  }
}
resource "google_compute_health_check" "tcp-8080" {
  name               = "tcp-8080"
  project = "${google_project.victim_project.id}"
  check_interval_sec = 1
  timeout_sec        = 1

  tcp_health_check {
    port = "8080"
  }
}
resource "google_compute_instance_group" "ilb-webservers" {
  name        = "ilb-webserver-instance-group"
  description = "An instance group for the webserver"
  project     = "${google_project.victim_project.id}"
  zone        = "${var.GCP_Zone}"

  instances = [
    "${google_compute_instance.jenkins2.self_link}",
  ]
}
resource "google_compute_region_backend_service" "ilb-webserver" {
  name          = "ilb-webserver"
  project       = "${google_project.victim_project.id}"
  region        = "${var.GCP_Region}"
  health_checks = ["${google_compute_health_check.tcp-8080.self_link}"]

  backend {
    group = "${google_compute_instance_group.ilb-webservers.self_link}"
  }
}
resource "google_compute_forwarding_rule" "ilb-webserver-forwarding-rule" {
  name                  = "ilb-webserver-forwarding-rule"
  project               = "${google_project.victim_project.id}"
  load_balancing_scheme = "INTERNAL"
  ip_address            = "${var.WebLB_IP}"
  ports                 = ["8080"]
  network               = "${google_compute_network.trust_network.self_link}"
  subnetwork            = "${google_compute_subnetwork.trust_subnet.self_link}"
  backend_service       = "${google_compute_region_backend_service.ilb-webserver.self_link}"
}