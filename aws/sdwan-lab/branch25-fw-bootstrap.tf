# Create a BootStrap S3 Bucket

resource "random_id" "branch25-fw-bucket_prefix" {
  byte_length = 4
}

resource "aws_s3_bucket" "branch25-fw-bootstrap-bucket" {
  #branch25-fw-bucket_prefix = "${var.branch25-fw-bucket_prefix}"
  bucket        = "branch25-fw-${lower(random_id.branch25-fw-bucket_prefix.hex)}"
  acl           = "private"
  force_destroy = true

  tags {
    Name = "branch25-fw-bootstrap-bucket"
  }
}

#resource "aws_s3_bucket_object" "branch25-fw-bootstrap_xml" {
#  depends_on = ["aws_s3_bucket.branch25-fw-bootstrap-bucket"]
#  bucket     = "branch25-fw-${lower(random_id.branch25-fw-bucket_prefix.hex)}"
#  acl        = "private"
#  key        = "config/bootstrap.xml"
#  source     = "branch25-fw-bootstrap/bootstrap.xml"
#}

resource "aws_s3_bucket_object" "branch25-fw-init-cft_txt" {
  bucket     = "branch25-fw-${lower(random_id.branch25-fw-bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.branch25-fw-bootstrap-bucket"]
  acl        = "private"
  key        = "config/init-cfg.txt"
  source     = "branch25-fw-bootstrap/init-cfg.txt"
}

resource "aws_s3_bucket_object" "branch25-fw-software" {
  bucket     = "branch25-fw-${lower(random_id.branch25-fw-bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.branch25-fw-bootstrap-bucket"]
  acl        = "private"
  key        = "software/"
  source     = "/dev/null"
}

resource "aws_s3_bucket_object" "branch25-fw-license" {
  bucket     = "branch25-fw-${lower(random_id.branch25-fw-bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.branch25-fw-bootstrap-bucket"]
  acl        = "private"
  key        = "license/"
  source     = "/dev/null"
}

resource "aws_s3_bucket_object" "branch25-fw-content" {
  bucket     = "branch25-fw-${lower(random_id.branch25-fw-bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.branch25-fw-bootstrap-bucket"]
  acl        = "private"
  key        = "content/"
  source     = "/dev/null"
}
