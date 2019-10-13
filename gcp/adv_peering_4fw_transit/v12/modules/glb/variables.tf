variable "project" {
  description = "The project to deploy to, if not set the default provider project is used."
  default     = ""
}

variable "ip_version" {
  description = "IP version for the Global address (IPv4 or v6) - Empty defaults to IPV4"
  default     = ""
}

variable "name" {
  description = "Name for the forwarding rule and prefix for supporting resources"
}

variable "backends" {
  description = "Map backend indices to list of backend maps."
  type        = map(list(object({
    group                        = string
    balancing_mode               = string
    capacity_scaler              = number
    description                  = string
    max_connections              = number
    max_connections_per_instance = number
    max_rate                     = number
    max_rate_per_instance        = number
    max_utilization              = number
  })))
}

variable "backend_params" {
  description = "Comma-separated encoded list of parameters in order: health check path, service port name, service port, backend timeout seconds"
  type        = list(string)
}

variable "backend_protocol" {
  description = "The protocol with which to talk to the backend service"
  default     = "HTTP"
}

variable "create_url_map" {
  description = "Set to `false` if url_map variable is provided."
  default     = true
}

variable "url_map" {
  description = "The url_map resource to use. Default is to send all traffic to first backend."
  default     = ""
}

variable "http_forward" {
  description = "Set to `false` to disable HTTP port 80 forward"
  default     = true
}

variable "ssl" {
  description = "Set to `true` to enable SSL support, requires variable `ssl_certificates` - a list of self_link certs"
  default     = false
}

variable "private_key" {
  description = "Content of the private SSL key. Required if `ssl` is `true` and `ssl_certificates` is empty."
  default     = ""
}

variable "certificate" {
  description = "Content of the SSL certificate. Required if `ssl` is `true` and `ssl_certificates` is empty."
  default     = ""
}

variable "use_ssl_certificates" {
  description = "If true, use the certificates provided by `ssl_certificates`, otherwise, create cert from `private_key` and `certificate`"
  default     = false
}

variable "ssl_certificates" {
  type        = list(string)
  description = "SSL cert self_link list. Required if `ssl` is `true` and no `private_key` and `certificate` is provided."
  default     = []
}

variable "security_policy" {
  description = "The resource URL for the security policy to associate with the backend service"
  default     = ""
}

variable "cdn" {
  description = "Set to `true` to enable cdn on backend."
  default     = "false"
}

