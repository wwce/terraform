
variable project {
  type        = string
  description = "The project to deploy to, if not set the default provider project is used."
  default     = ""
}

variable region {
  type        = string
  description = "Region used for GCP resources."
}

variable name {
  type        = string
  description = "Name for the forwarding rule and prefix for supporting resources."
}

variable service_port {
  type        = number
  description = "TCP port your service is listening on."
}

variable session_affinity {
  type        = string
  description = "How to distribute load. Options are `NONE`, `CLIENT_IP` and `CLIENT_IP_PROTO`"
  default     = "NONE"
}

variable disable_health_check {
  type        = bool
  description = "Disables the health check on the target pool."
  default     = false
}

variable health_check {
  description = "Health check to determine whether instances are responsive and able to do work"
  type = object({
    check_interval_sec  = number
    healthy_threshold   = number
    timeout_sec         = number
    unhealthy_threshold = number
    port                = number
    request_path        = string
    host                = string
  })
  default = {
    check_interval_sec  = null
    healthy_threshold   = null
    timeout_sec         = null
    unhealthy_threshold = null
    port                = null
    request_path        = null
    host                = null
  }
}

variable ip_address {
  description = "IP address of the external load balancer, if empty one will be assigned."
  default     = null
}

variable ip_protocol {
  description = "The IP protocol for the frontend forwarding rule: TCP, UDP, ESP, AH, SCTP or ICMP."
  default     = "TCP"
}

variable instances {
  type        = list(string)
  default     = null
}