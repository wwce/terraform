output "completion" {
  value = null_resource.dependency_setter.id
}

output "bucket_name" {
  value = google_storage_bucket.bootstrap.name
}

