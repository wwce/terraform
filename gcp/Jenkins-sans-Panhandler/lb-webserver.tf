resource "google_compute_instance_group" "webservers" {
  name        = "webserver-instance-group"
  description = "An instance group for the webserver"
  project     = google_project.blue_team_project.project_id
  zone        = var.GCP_Zone

  instances = [
    google_compute_instance.webserver.self_link,
  ]
  named_port {
    name = "http-8080"
    port = "8080"
  }
}

resource "google_compute_target_pool" "webservers" {
  name    = "armor-pool-webservers"
  project = google_project.blue_team_project.project_id

  instances = [
    google_compute_instance.webserver.self_link,
  ]

  health_checks = [
    google_compute_http_health_check.health.name,
  ]
}

resource "google_compute_http_health_check" "health" {
  name               = "armor-healthcheck"
  project            = google_project.blue_team_project.project_id
  port               = 8080
  request_path       = var.HC_Request_Path
  check_interval_sec = 1
  timeout_sec        = 1
}

resource "google_compute_backend_service" "webservers" {
  name        = "armor-backend-webservers"
  description = "Our company website"
  project     = google_project.blue_team_project.project_id
  port_name   = "http-8080"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = false

  backend {
    group = google_compute_instance_group.webservers.self_link
  }

  security_policy = google_compute_security_policy.security-policy-webservers.self_link

  health_checks = [google_compute_http_health_check.health.self_link]
}

resource "google_compute_security_policy" "security-policy-webservers" {
  name        = "armor-security-policy-webservers"
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

resource "google_compute_global_forwarding_rule" "webservers" {
  name       = "armor-rule-webservers"
  project    = google_project.blue_team_project.project_id
  target     = google_compute_target_http_proxy.webservers.self_link
  port_range = "80"
}

resource "google_compute_target_http_proxy" "webservers" {
  name    = "armor-proxy-webservers"
  project = google_project.blue_team_project.project_id
  url_map = google_compute_url_map.webservers.self_link
}

resource "google_compute_url_map" "webservers" {
  name            = "armor-url-map-webservers"
  project         = google_project.blue_team_project.project_id
  default_service = google_compute_backend_service.webservers.self_link

  host_rule {
    hosts        = ["sans-firewalls.com"]
    path_matcher = "allpaths"
  }
  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.webservers.self_link

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.webservers.self_link
    }
  }
}

