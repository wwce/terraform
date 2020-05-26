output vm_names {
  value = google_compute_instance.default.*.name
}

output vm_self_link {
  value = google_compute_instance.default.*.self_link
}