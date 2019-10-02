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
  default = []
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

resource "google_storage_bucket_object" "config_full" {
  count  = "${length(var.config) > 0 ? length(var.config) : "0" }"
  name   = "config/${element(var.config, count.index)}"
  source = "${var.file_location}${element(var.config, count.index)}"
  bucket = "${google_storage_bucket.bootstrap.name}"
}

resource "google_storage_bucket_object" "content_full" {
  count  = "${length(var.content) > 0 ? length(var.content) : "0" }"
  name   = "content/${element(var.content, count.index)}"
  source = "${var.file_location}${element(var.content, count.index)}"
  bucket = "${google_storage_bucket.bootstrap.name}"
}

resource "google_storage_bucket_object" "license_full" {
  count  = "${length(var.license) > 0 ? length(var.license) : "0" }"
  name   = "license/${element(var.license, count.index)}"
  source = "${var.file_location}${element(var.license, count.index)}"
  bucket = "${google_storage_bucket.bootstrap.name}"
}
resource "google_storage_bucket_object" "software_full" {
  count  = "${length(var.software) > 0 ? length(var.software) : "0" }"
  name   = "software/${element(var.software, count.index)}"
  source = "${var.file_location}${element(var.software, count.index)}"
  bucket = "${google_storage_bucket.bootstrap.name}"
}
resource "google_storage_bucket_object" "config_empty" {
  count  = "${length(var.config) == 0 ? 1 : 0 }"
  name   = "config/"
  content = "config/"
  bucket = "${google_storage_bucket.bootstrap.name}"
}

resource "google_storage_bucket_object" "content_empty" {
  count  = "${length(var.content) == 0 ? 1 : 0 }"
  name   = "content/"
  content = "content/"
  bucket = "${google_storage_bucket.bootstrap.name}"
}

resource "google_storage_bucket_object" "license_empty" {
  count  = "${length(var.license) == 0 ? 1 : 0 }"
  name   = "license/"
  content = "license/"
  bucket = "${google_storage_bucket.bootstrap.name}"
}

resource "google_storage_bucket_object" "software_empty" {
  count  = "${length(var.software) == 0 ? 1 : 0 }"
  name   = "software/"
  content = "software/"
  bucket = "${google_storage_bucket.bootstrap.name}"
}


resource "null_resource" "dependency_setter" {
  depends_on = [
    "google_storage_bucket.bootstrap",
    "google_storage_bucket_object.config_full",
    "google_storage_bucket_object.content_full",
    "google_storage_bucket_object.license_full",
    "google_storage_bucket_object.software_full",
    "google_storage_bucket_object.config_empty",
    "google_storage_bucket_object.content_empty",
    "google_storage_bucket_object.license_empty",
    "google_storage_bucket_object.software_empty",
  ]
}

output "completion" {
  value = "${null_resource.dependency_setter.id}"
}

output "bucket_name" {
  value = "${google_storage_bucket.bootstrap.name}"
}
