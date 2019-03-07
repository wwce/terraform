# Create a BootStrap S3 Bucket

resource "aws_s3_bucket" "bootstrap_bucket" {
  bucket        = "${var.bootstrap_s3bucket}"
  acl           = "private"
  force_destroy = true

  tags {
    Name = "bootstrap_bucket"
  }
}

# Create Folders and Upload Bootstrap Files
resource "aws_s3_bucket_object" "bootstrap_xml" {
  bucket = "${aws_s3_bucket.bootstrap_bucket.id}"
  acl    = "private"
  key    = "config/bootstrap.xml"
  source = "bootstrap/bootstrap.xml"
}

resource "aws_s3_bucket_object" "init-cft_txt" {
  bucket = "${aws_s3_bucket.bootstrap_bucket.id}"
  acl    = "private"
  key    = "config/init-cfg.txt"
  source = "bootstrap/init-cfg.txt"
}

resource "aws_s3_bucket_object" "software" {
  bucket = "${aws_s3_bucket.bootstrap_bucket.id}"
  acl    = "private"
  key    = "software/"
  source = "/dev/null"
}

resource "aws_s3_bucket_object" "license" {
  bucket = "${aws_s3_bucket.bootstrap_bucket.id}"
  acl    = "private"
  key    = "license/"
  source = "/dev/null"
}

resource "aws_s3_bucket_object" "content" {
  bucket = "${aws_s3_bucket.bootstrap_bucket.id}"
  acl    = "private"
  key    = "content/"
  source = "/dev/null"
}
