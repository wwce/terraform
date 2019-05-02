# Create a BootStrap S3 Bucket

resource "random_id" "bucket_prefix" {
  byte_length = 4
}

#data "aws_s3_bucket" "jenkins" {
#  bucket = "bootstrap_bucket"

#region = "${var.aws_region}"
#}

resource "aws_s3_bucket" "bootstrap_bucket" {
  #bucket_prefix = "${var.bucket_prefix}"
  bucket        = "sec-frame-jenkins-${lower(random_id.bucket_prefix.hex)}"
  acl           = "private"
  force_destroy = true

  tags {
    Name = "bootstrap_bucket"
  }
}

resource "aws_s3_bucket_object" "bootstrap_xml" {
  depends_on = ["aws_s3_bucket.bootstrap_bucket"]
  bucket     = "sec-frame-jenkins-${lower(random_id.bucket_prefix.hex)}"
  acl        = "private"
  key        = "config/bootstrap.xml"
  source     = "bootstrap/bootstrap.xml"
}

resource "aws_s3_bucket_object" "init-cft_txt" {
  bucket     = "sec-frame-jenkins-${lower(random_id.bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.bootstrap_bucket"]
  acl        = "private"
  key        = "config/init-cfg.txt"
  source     = "bootstrap/init-cfg.txt"
}

resource "aws_s3_bucket_object" "software" {
  bucket     = "sec-frame-jenkins-${lower(random_id.bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.bootstrap_bucket"]
  acl        = "private"
  key        = "software/"
  source     = "/dev/null"
}

resource "aws_s3_bucket_object" "license" {
  bucket     = "sec-frame-jenkins-${lower(random_id.bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.bootstrap_bucket"]
  acl        = "private"
  key        = "license/"
  source     = "/dev/null"
}

resource "aws_s3_bucket_object" "content" {
  bucket     = "sec-frame-jenkins-${lower(random_id.bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.bootstrap_bucket"]
  acl        = "private"
  key        = "content/"
  source     = "/dev/null"
}
