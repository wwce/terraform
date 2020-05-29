output forwarding_rule {
  value = google_compute_forwarding_rule.default.*.self_link
}

output forwarding_rule_ip_address {
  value = google_compute_forwarding_rule.default.ip_address
}