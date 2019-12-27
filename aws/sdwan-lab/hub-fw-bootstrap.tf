# Create a BootStrap S3 Bucket

resource "random_id" "hub-fw-bucket_prefix" {
  byte_length = 4
}

resource "aws_s3_bucket" "hub-fw-bootstrap-bucket" {
  #hub-fw-bucket_prefix = "${var.hub-fw-bucket_prefix}"
  bucket        = "hub-fw-${lower(random_id.hub-fw-bucket_prefix.hex)}"
  acl           = "private"
  force_destroy = true

  tags {
    Name = "hub-fw-bootstrap-bucket"
  }
}

#resource "aws_s3_bucket_object" "hub-fw-bootstrap_xml" {
#  depends_on = ["aws_s3_bucket.hub-fw-bootstrap-bucket"]
#  bucket     = "hub-fw-${lower(random_id.hub-fw-bucket_prefix.hex)}"
#  acl        = "private"
#  key        = "config/bootstrap.xml"
#  source     = "/dev/null"
#}

resource "aws_s3_bucket_object" "hub-fw-init-cft_txt" {
  bucket     = "hub-fw-${lower(random_id.hub-fw-bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.hub-fw-bootstrap-bucket"]
  acl        = "private"
  key        = "config/init-cfg.txt"
  source     = "hub-fw-bootstrap/init-cfg.txt"
}

resource "aws_s3_bucket_object" "hub-fw-software" {
  bucket     = "hub-fw-${lower(random_id.hub-fw-bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.hub-fw-bootstrap-bucket"]
  acl        = "private"
  key        = "software/"
  source     = "/dev/null"
}

resource "aws_s3_bucket_object" "hub-fw-license" {
  bucket     = "hub-fw-${lower(random_id.hub-fw-bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.hub-fw-bootstrap-bucket"]
  acl        = "private"
  key        = "license/"
  source     = "/dev/null"
}

resource "aws_s3_bucket_object" "hub-fw-content" {
  bucket     = "hub-fw-${lower(random_id.hub-fw-bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.hub-fw-bootstrap-bucket"]
  acl        = "private"
  key        = "content/"
  source     = "/dev/null"
}
