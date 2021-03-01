resource "google_compute_instance_group" "firewalls" {
  name        = "firewalls-instance-group"
  description = "An instance group for the single FW instance"
  project     = google_project.blue_team_project.project_id
  zone        = var.GCP_Zone

  instances = [
    google_compute_instance.firewall.self_link,
  ]
  named_port {
    name = "http-8080"
    port = "8080"
  }
}

resource "google_compute_target_pool" "firewalls" {
  name    = "armor-pool-firewalls"
  project = google_project.blue_team_project.project_id

  instances = [
    google_compute_instance.firewall.self_link,
  ]

  health_checks = [
    google_compute_http_health_check.health.name,
  ]
}

resource "google_compute_backend_service" "firewalls" {
  name        = "armor-backend-firewalls"
  description = "With FW"
  project     = google_project.blue_team_project.project_id
  port_name   = "http-8080"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = false

  backend {
    group = google_compute_instance_group.firewalls.self_link
  }

  security_policy = google_compute_security_policy.security-policy-firewalls.self_link

  health_checks = [google_compute_http_health_check.health.self_link]
}

resource "google_compute_security_policy" "security-policy-firewalls" {
  name        = "armor-security-policy-firewalls"
  description = "example security policy"
  project     = google_project.blue_team_project.project_id

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

  rule {
    action   = "deny(403)"
    priority = "900"
    match {
        expr {
            expression = "evaluatePreconfiguredExpr('xss-stable')"
        }
    }
  }

  rule {
    action   = "deny(403)"
    priority = "910"
    match {
        expr {
            expression = "evaluatePreconfiguredExpr('sqli-stable')"
        }
    }
  }

  rule {
    action   = "deny(403)"
    priority = "920"
    match {
        expr {
            expression = "evaluatePreconfiguredExpr('lfi-stable')"
        }
    }
  }

  rule {
    action   = "deny(403)"
    priority = "930"
    match {
        expr {
            expression = "evaluatePreconfiguredExpr('rce-stable')"
        }
    }
  }

  rule {
    action   = "deny(403)"
    priority = "940"
    match {
        expr {
            expression = "evaluatePreconfiguredExpr('rfi-stable')"
        }
    }
  }

  rule {
    action   = "deny(403)"
    priority = "950"
    match {
        expr {
            expression = "evaluatePreconfiguredExpr('sessionfixation-stable')"
        }
    }
  }

  rule {
    action   = "deny(403)"
    priority = "960"
    match {
        expr {
            expression = "evaluatePreconfiguredExpr('scannerdetection-stable')"
        }
    }
  }

  rule {
    action   = "deny(403)"
    priority = "970"
    match {
        expr {
            expression = "evaluatePreconfiguredExpr('protocolattack-stable')"
        }
    }
  }

  rule {
    action   = "deny(403)"
    priority = "980"
    match {
        expr {
            expression = "evaluatePreconfiguredExpr('php-stable')"
        }
    }
  }

  rule {
    action   = "deny(403)"
    priority = "990"
    match {
        expr {
            expression = "evaluatePreconfiguredExpr('methodenforcement-stable')"
        }
    }
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
  project    = google_project.blue_team_project.project_id
  target     = google_compute_target_http_proxy.firewalls.self_link
  port_range = "80"
}

resource "google_compute_target_http_proxy" "firewalls" {
  name    = "armor-proxy-firewalls"
  project = google_project.blue_team_project.project_id
  url_map = google_compute_url_map.firewalls.self_link
}

resource "google_compute_url_map" "firewalls" {
  name            = "armor-url-map-firewalls"
  project         = google_project.blue_team_project.project_id
  default_service = google_compute_backend_service.firewalls.self_link

  host_rule {
    hosts        = ["with-firewalls.com"]
    path_matcher = "allpaths"
  }
  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.firewalls.self_link

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.firewalls.self_link
    }
  }
}