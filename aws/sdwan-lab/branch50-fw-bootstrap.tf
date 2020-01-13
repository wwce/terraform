# Create a BootStrap S3 Bucket

resource "random_id" "branch50-fw-bucket_prefix" {
  byte_length = 4
}

resource "aws_s3_bucket" "branch50-fw-bootstrap-bucket" {
  #branch50-fw-bucket_prefix = "${var.branch50-fw-bucket_prefix}"
  bucket        = "branch50-fw-${lower(random_id.branch50-fw-bucket_prefix.hex)}"
  acl           = "private"
  force_destroy = true

  tags {
    Name = "branch50-fw-bootstrap-bucket"
  }
}

#resource "aws_s3_bucket_object" "branch50-fw-bootstrap_xml" {
#  depends_on = ["aws_s3_bucket.branch50-fw-bootstrap-bucket"]
#  bucket     = "branch50-fw-${lower(random_id.branch50-fw-bucket_prefix.hex)}"
#  acl        = "private"
#  key        = "config/bootstrap.xml"
#  source     = "branch50-fw-bootstrap/bootstrap.xml"
#}

resource "aws_s3_bucket_object" "branch50-fw-init-cft_txt" {
  bucket     = "branch50-fw-${lower(random_id.branch50-fw-bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.branch50-fw-bootstrap-bucket"]
  acl        = "private"
  key        = "config/init-cfg.txt"
  source     = "branch50-fw-bootstrap/init-cfg.txt"
}

resource "aws_s3_bucket_object" "branch50-fw-software" {
  bucket     = "branch50-fw-${lower(random_id.branch50-fw-bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.branch50-fw-bootstrap-bucket"]
  acl        = "private"
  key        = "software/"
  source     = "/dev/null"
}

resource "aws_s3_bucket_object" "branch50-fw-license" {
  bucket     = "branch50-fw-${lower(random_id.branch50-fw-bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.branch50-fw-bootstrap-bucket"]
  acl        = "private"
  key        = "license/"
  source     = "/dev/null"
}

resource "aws_s3_bucket_object" "branch50-fw-content" {
  bucket     = "branch50-fw-${lower(random_id.branch50-fw-bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.branch50-fw-bootstrap-bucket"]
  acl        = "private"
  key        = "content/"
  source     = "/dev/null"
}
