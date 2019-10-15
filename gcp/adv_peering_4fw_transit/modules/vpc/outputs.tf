output "subnetwork_id" {
  value = google_compute_subnetwork.default.*.id
}

output "subnetwork_name" {
  value = google_compute_subnetwork.default.*.name
}

output "subnetwork_self_link" {
  value = google_compute_subnetwork.default.*.self_link
}

output "vpc_name" {
  value = google_compute_network.default.*.name
}

output "vpc_id" {
  value = google_compute_network.default.*.id[0]
}

output "vpc_self_link" {
  value = google_compute_network.default.*.self_link[0]
}

