
variable project {
  description = "The project to deploy to, if not set the default provider project is used."
  default     = ""
}

variable ip_version {
  description = "IP version for the Global address (IPv4 or v6) - Empty defaults to IPV4"
  default     = ""
}

variable name {
  description = "Name for the forwarding rule and prefix for supporting resources"
}

variable backends {
  description = "Map backend indices to list of backend maps."
  type        = "map"
}

variable backend_params {
  description = "Comma-separated encoded list of parameters in order: health check path, service port name, service port, backend timeout seconds"
  type        = "list"
}

variable backend_protocol {
  description = "The protocol with which to talk to the backend service"
  default     = "HTTP"
}

variable create_url_map {
  description = "Set to `false` if url_map variable is provided."
  default     = true
}

variable url_map {
  description = "The url_map resource to use. Default is to send all traffic to first backend."
  default     = ""
}

variable http_forward {
  description = "Set to `false` to disable HTTP port 80 forward"
  default     = true
}

variable ssl {
  description = "Set to `true` to enable SSL support, requires variable `ssl_certificates` - a list of self_link certs"
  default     = false
}

variable private_key {
  description = "Content of the private SSL key. Required if `ssl` is `true` and `ssl_certificates` is empty."
  default     = ""
}

variable certificate {
  description = "Content of the SSL certificate. Required if `ssl` is `true` and `ssl_certificates` is empty."
  default     = ""
}

variable use_ssl_certificates {
  description = "If true, use the certificates provided by `ssl_certificates`, otherwise, create cert from `private_key` and `certificate`"
  default     = false
}

variable ssl_certificates {
  type        = "list"
  description = "SSL cert self_link list. Required if `ssl` is `true` and no `private_key` and `certificate` is provided."
  default     = []
}

variable security_policy {
  description = "The resource URL for the security policy to associate with the backend service"
  default     = ""
}

variable cdn {
  description = "Set to `true` to enable cdn on backend."
  default     = "false"
}


resource "google_compute_global_forwarding_rule" "http" {
  project    = "${var.project}"
  count      = "${var.http_forward ? 1 : 0}"
  name       = "${var.name}"
  target     = "${google_compute_target_http_proxy.default.self_link}"
  ip_address = "${google_compute_global_address.default.address}"
  port_range = "80"
  depends_on = ["google_compute_global_address.default"]
}

resource "google_compute_global_forwarding_rule" "https" {
  project    = "${var.project}"
  count      = "${var.ssl ? 1 : 0}"
  name       = "${var.name}-https"
  target     = "${google_compute_target_https_proxy.default.self_link}"
  ip_address = "${google_compute_global_address.default.address}"
  port_range = "443"
  depends_on = ["google_compute_global_address.default"]
}

resource "google_compute_global_address" "default" {
  project    = "${var.project}"
  name       = "${var.name}-address"
  ip_version = "${var.ip_version}"
}

# HTTP proxy when ssl is false
resource "google_compute_target_http_proxy" "default" {
  project = "${var.project}"
  count   = "${var.http_forward ? 1 : 0}"
  name    = "${var.name}-http-proxy"
  url_map = "${element(compact(concat(list(var.url_map), google_compute_url_map.default.*.self_link)), 0)}"
}

# HTTPS proxy  when ssl is true
resource "google_compute_target_https_proxy" "default" {
  project          = "${var.project}"
  count            = "${var.ssl ? 1 : 0}"
  name             = "${var.name}-https-proxy"
  url_map          = "${element(compact(concat(list(var.url_map), google_compute_url_map.default.*.self_link)), 0)}"
  ssl_certificates = ["${compact(concat(var.ssl_certificates, google_compute_ssl_certificate.default.*.self_link))}"]
}

resource "google_compute_ssl_certificate" "default" {
  project     = "${var.project}"
  count       = "${(var.ssl && !var.use_ssl_certificates) ? 1 : 0}"
  name_prefix = "${var.name}-certificate-"
  private_key = "${var.private_key}"
  certificate = "${var.certificate}"

  lifecycle = {
    create_before_destroy = true
  }
}

resource "google_compute_url_map" "default" {
  project         = "${var.project}"
  count           = "${var.create_url_map ? 1 : 0}"
  name            = "${var.name}"
  default_service = "${google_compute_backend_service.default.0.self_link}"
}

resource "google_compute_backend_service" "default" {
  project         = "${var.project}"
  count           = "${length(var.backend_params)}"
  name            = "${var.name}-backend-${count.index}"
  port_name       = "${element(split(",", element(var.backend_params, count.index)), 1)}"
  protocol        = "${var.backend_protocol}"
  timeout_sec     = "${element(split(",", element(var.backend_params, count.index)), 3)}"
  backend         = ["${var.backends["${count.index}"]}"]
  health_checks   = ["${element(google_compute_http_health_check.default.*.self_link, count.index)}"]
  security_policy = "${var.security_policy}"
  enable_cdn      = "${var.cdn}"
}

resource "google_compute_http_health_check" "default" {
  project      = "${var.project}"
  count        = "${length(var.backend_params)}"
  name         = "${var.name}-check-${count.index}"
  request_path = "${element(split(",", element(var.backend_params, count.index)), 0)}"
  port         = "${element(split(",", element(var.backend_params, count.index)), 2)}"
}

output "address" {
  value = "${google_compute_global_address.default.address}"
}