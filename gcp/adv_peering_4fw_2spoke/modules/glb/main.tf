resource "google_compute_global_forwarding_rule" "http" {
  count      = var.http_forward ? 1 : 0
  name       = "${var.name}-http"
  target     = google_compute_target_http_proxy.default[0].self_link
  ip_address = google_compute_global_address.default.address
  port_range = "80"
}

resource "google_compute_global_forwarding_rule" "https" {
  count      = var.ssl ? 1 : 0
  name       = "${var.name}-https"
  target     = google_compute_target_https_proxy.default[0].self_link
  ip_address = google_compute_global_address.default.address
  port_range = "443"
}

resource "google_compute_global_address" "default" {
  name       = "${var.name}-address"
  ip_version = var.ip_version
}

# HTTP proxy when ssl is false
resource "google_compute_target_http_proxy" "default" {
  count = var.http_forward ? 1 : 0
  name  = "${var.name}-http-proxy"
  url_map = compact(
    concat([
    var.url_map], google_compute_url_map.default.*.self_link),
  )[0]
}
# HTTPS proxy  when ssl is true
resource "google_compute_target_https_proxy" "default" {
  count = var.ssl ? 1 : 0
  name  = "${var.name}-https-proxy"
  url_map = compact(
    concat([
  var.url_map], google_compute_url_map.default.*.self_link), )[0]
  ssl_certificates = compact(concat(var.ssl_certificates, google_compute_ssl_certificate.default.*.self_link, ), )
}

resource "google_compute_ssl_certificate" "default" {
  count       = var.ssl && ! var.use_ssl_certificates ? 1 : 0
  name_prefix = "${var.name}-certificate"
  private_key = var.private_key
  certificate = var.certificate

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_url_map" "default" {
  count           = var.create_url_map ? 1 : 0
  name            = "${var.name}"
  default_service = google_compute_backend_service.default[0].self_link
}

resource "google_compute_backend_service" "default" {
  count       = length(var.backend_params)
  name        = "${var.name}-${count.index}"
  port_name   = split(",", var.backend_params[count.index])[1]
  protocol    = var.backend_protocol
  timeout_sec = split(",", var.backend_params[count.index])[3]
  dynamic "backend" {
    for_each = var.backends[count.index]
    content {
      balancing_mode               = lookup(backend.value, "balancing_mode")
      capacity_scaler              = lookup(backend.value, "capacity_scaler")
      description                  = lookup(backend.value, "description")
      group                        = lookup(backend.value, "group")
      max_connections              = lookup(backend.value, "max_connections")
      max_connections_per_instance = lookup(backend.value, "max_connections_per_instance")
      max_rate                     = lookup(backend.value, "max_rate")
      max_rate_per_instance        = lookup(backend.value, "max_rate_per_instance")
      max_utilization              = lookup(backend.value, "max_utilization")
    }
  }
  health_checks = [
  google_compute_http_health_check.default[count.index].self_link]
  security_policy = var.security_policy
  enable_cdn      = var.cdn
}

resource "google_compute_http_health_check" "default" {
  count        = length(var.backend_params)
  name         = "${var.name}-check-${count.index}"
  request_path = split(",", var.backend_params[count.index])[0]
  port         = split(",", var.backend_params[count.index])[2]
}
