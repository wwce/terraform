output "forwarding_rule" {
  value = google_compute_forwarding_rule.main.*.self_link
}

