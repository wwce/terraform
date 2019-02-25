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
  source = "bootstrap_files/bootstrap.xml"
}

resource "aws_s3_bucket_object" "init-cft_txt" {
  bucket = "${aws_s3_bucket.bootstrap_bucket.id}"
  acl    = "private"
  key    = "config/init-cfg.txt"
  source = "bootstrap_files/init-cfg.txt"
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

/* Roles, ACLs, Permissions, etc... */

resource "aws_iam_role" "bootstrap_role" {
  name = "ngfw_bootstrap_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
      "Service": "ec2.amazonaws.com"
    },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "bootstrap_policy" {
  name = "ngfw_bootstrap_policy"
  role = "${aws_iam_role.bootstrap_role.id}"

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${var.bootstrap_s3bucket}"
    },
    {
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${var.bootstrap_s3bucket}/*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "bootstrap_profile" {
  name = "ngfw_bootstrap_profile"
  role = "${aws_iam_role.bootstrap_role.name}"
  path = "/"
}
