resource "random_string" "randomstring" {
  length      = 30
  min_numeric = 30
  special     = false
}

resource "aws_s3_bucket" "bootstrap" {
  bucket        = "${var.bucket_name_random ? join("", list(var.bucket_name, "-", random_string.randomstring.result)) : var.bucket_name}"
  acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket_object" "config_full" {
  count  = "${length(var.config) > 0 ? length(var.config) : "0" }"
  key    = "config/${element(var.config, count.index)}"
  source = "${var.file_location}${element(var.config, count.index)}"
  bucket = "${aws_s3_bucket.bootstrap.id}"
  acl    = "private"
}

resource "aws_s3_bucket_object" "content_full" {
  count  = "${length(var.content) > 0 ? length(var.content) : "0" }"
  key    = "content/${element(var.content, count.index)}"
  source = "${var.file_location}${element(var.content, count.index)}"
  bucket = "${aws_s3_bucket.bootstrap.id}"
  acl    = "private"
}

resource "aws_s3_bucket_object" "software_full" {
  count  = "${length(var.software) > 0 ? length(var.software) : "0" }"
  key    = "software/${element(var.software, count.index)}"
  source = "${var.file_location}${element(var.software, count.index)}"
  bucket = "${aws_s3_bucket.bootstrap.id}"
  acl    = "private"
}

resource "aws_s3_bucket_object" "license_full" {
  count  = "${length(var.license) > 0 ? length(var.license) : "0" }"
  key    = "license/${element(var.license, count.index)}"
  source = "${var.file_location}${element(var.license, count.index)}"
  bucket = "${aws_s3_bucket.bootstrap.id}"
  acl    = "private"
}

resource "aws_s3_bucket_object" "other" {
  count  = "${length(var.other) > 0 ? length(var.other) : "0" }"
  key    = "${element(var.other, count.index)}"
  source = "${var.file_location}${element(var.other, count.index)}"
  bucket = "${aws_s3_bucket.bootstrap.id}"
  acl    = "private"
}

resource "aws_s3_bucket_object" "config_empty" {
  count   = "${length(var.config) == 0 ? 1 : 0 }"
  key     = "config/"
  content = "config/"
  bucket  = "${aws_s3_bucket.bootstrap.id}"
  acl     = "private"
}

resource "aws_s3_bucket_object" "content_empty" {
  count   = "${length(var.content) == 0 ? 1 : 0 }"
  key     = "content/"
  content = "content/"
  bucket  = "${aws_s3_bucket.bootstrap.id}"
  acl     = "private"
}

resource "aws_s3_bucket_object" "license_empty" {
  count   = "${length(var.license) == 0 ? 1 : 0 }"
  key     = "license/"
  content = "license/"
  bucket  = "${aws_s3_bucket.bootstrap.id}"
  acl     = "private"
}

resource "aws_s3_bucket_object" "software_empty" {
  count   = "${length(var.software) == 0 ? 1 : 0 }"
  key     = "software/"
  content = "software/"
  bucket  = "${aws_s3_bucket.bootstrap.id}"
  acl     = "private"
}



resource "null_resource" "dependency_setter" {
  depends_on = [
    "aws_s3_bucket.bootstrap",
    "aws_s3_bucket_object.config_full",
    "aws_s3_bucket_object.content_full",
    "aws_s3_bucket_object.license_full",
    "aws_s3_bucket_object.software_full",
    "aws_s3_bucket_object.other",
    "aws_s3_bucket_object.config_empty",
    "aws_s3_bucket_object.content_empty",
    "aws_s3_bucket_object.license_empty",
    "aws_s3_bucket_object.software_empty",
  ]
}
