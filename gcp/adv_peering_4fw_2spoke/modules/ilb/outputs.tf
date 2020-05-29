output "forwarding_rule" {
  value = google_compute_forwarding_rule.default.*.self_link
}

