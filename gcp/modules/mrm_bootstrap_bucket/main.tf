variable bucket_name {}

variable file_location {}

variable config {
  type    = "list"
  default = []
}

variable content {
  type    = "list"
  default = []
}

variable license {
  type    = "list"
  default = []
}

variable software {
  default = "/dev/null"
}

variable randomize_bucket_name {
  default = false
}

locals {
  bucket_name = "${var.randomize_bucket_name ? join("", list(var.bucket_name, random_string.randomstring.result)) : var.bucket_name}"
}

resource "random_string" "randomstring" {
  count       = "${var.randomize_bucket_name}"
  length      = 25
  min_lower   = 15
  min_numeric = 10
  special     = false
}

resource "google_storage_bucket" "bootstrap" {
  name          = "${local.bucket_name}"
  force_destroy = true
}

resource "google_storage_bucket_object" "config" {
  count  = "${length(var.config)}"
  name   = "config/${element(var.config, count.index)}"
  source = "${var.file_location}${element(var.config, count.index)}"
  bucket = "${google_storage_bucket.bootstrap.name}"
}

resource "google_storage_bucket_object" "content" {
  count  = "${length(var.content)}"
  name   = "content/${element(var.content, count.index)}"
  source = "${var.file_location}${element(var.content, count.index)}"
  bucket = "${google_storage_bucket.bootstrap.name}"
}

resource "google_storage_bucket_object" "license" {
  count  = "${length(var.license)}"
  name   = "license/${element(var.license, count.index)}"
  source = "${var.file_location}${element(var.license, count.index)}"
  bucket = "${google_storage_bucket.bootstrap.name}"
}

resource "google_storage_bucket_object" "software" {
  name   = "software/"
  source = "${var.software}"
  bucket = "${google_storage_bucket.bootstrap.name}"
}

resource "null_resource" "dependency_setter" {
  depends_on = [
    "google_storage_bucket.bootstrap",
    "google_storage_bucket_object.config",
    "google_storage_bucket_object.content",
    "google_storage_bucket_object.license",
    "google_storage_bucket_object.software",
  ]
}

output "completion" {
  value = "${null_resource.dependency_setter.id}"
}

output "bucket_name" {
  value = "${google_storage_bucket.bootstrap.name}"
}
