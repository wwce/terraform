resource "google_compute_global_forwarding_rule" "http" {
  project    = var.project
  count      = var.http_forward ? 1 : 0
  name       = "${var.name}-http"
  target     = google_compute_target_http_proxy.default[0].self_link
  ip_address = google_compute_global_address.default.address
  port_range = "80"
  depends_on = [google_compute_global_address.default]
}

resource "google_compute_global_forwarding_rule" "https" {
  project    = var.project
  count      = var.ssl ? 1 : 0
  name       = "${var.name}-https"
  target     = google_compute_target_https_proxy.default[0].self_link
  ip_address = google_compute_global_address.default.address
  port_range = "443"
  depends_on = [google_compute_global_address.default]
}

resource "google_compute_global_address" "default" {
  project    = var.project
  name       = "${var.name}-address"
  ip_version = var.ip_version
} 

# HTTP proxy when ssl is false
resource "google_compute_target_http_proxy" "default" {
  project = var.project
  count   = var.http_forward ? 1 : 0
  name    = "${var.name}-http-proxy"
  url_map = element(
    compact(
      concat([var.url_map], google_compute_url_map.default.*.self_link),
    ),
    0,
  )
}

# HTTPS proxy  when ssl is true
resource "google_compute_target_https_proxy" "default" {
  project = var.project
  count   = var.ssl ? 1 : 0
  name    = "${var.name}-https-proxy"
  url_map = element(
    compact(
      concat([var.url_map], google_compute_url_map.default.*.self_link),
    ),
    0,
  )
  ssl_certificates = compact(
    concat(
      var.ssl_certificates,
      google_compute_ssl_certificate.default.*.self_link,
    ),
  )
}

resource "google_compute_ssl_certificate" "default" {
  project     = var.project
  count       = var.ssl && false == var.use_ssl_certificates ? 1 : 0
  name_prefix = "${var.name}-certificate"
  private_key = var.private_key
  certificate = var.certificate

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_url_map" "default" {
  project         = var.project
  count           = var.create_url_map ? 1 : 0
  name            = var.name
  default_service = google_compute_backend_service.default[0].self_link
}

resource "google_compute_backend_service" "default" {
  project         = var.project
  count           = length(var.backend_params)
  name            = "${var.name}"
  port_name       = split(",", var.backend_params[count.index])[1]
  protocol        = var.backend_protocol
  timeout_sec     = split(",", var.backend_params[count.index])[3]
  dynamic "backend" {
    for_each = var.backends[count.index]
    content {
      balancing_mode               = lookup(backend.value, "balancing_mode", null)
      capacity_scaler              = lookup(backend.value, "capacity_scaler", null)
      description                  = lookup(backend.value, "description", null)
      group                        = lookup(backend.value, "group", null)
      max_connections              = lookup(backend.value, "max_connections", null)
      max_connections_per_endpoint = lookup(backend.value, "max_connections_per_endpoint", null)
      max_connections_per_instance = lookup(backend.value, "max_connections_per_instance", null)
      max_rate                     = lookup(backend.value, "max_rate", null)
      max_rate_per_endpoint        = lookup(backend.value, "max_rate_per_endpoint", null)
      max_rate_per_instance        = lookup(backend.value, "max_rate_per_instance", null)
      max_utilization              = lookup(backend.value, "max_utilization", null)
    }
  }
  health_checks   = [
    google_compute_http_health_check.default[count.index].self_link
  ]
  security_policy = var.security_policy
  enable_cdn      = var.cdn
}

resource "google_compute_http_health_check" "default" {
  project      = var.project
  count        = length(var.backend_params)
  name         = "${var.name}-check-${count.index}"
  request_path = element(split(",", element(var.backend_params, count.index)), 0)
  port         = element(split(",", element(var.backend_params, count.index)), 2)
}

