# Create a BootStrap S3 Bucket

resource "aws_s3_bucket" "bootstrap_bucket4" {
  bucket        = "${var.bootstrap_s3bucket4}"
  acl           = "private"
  force_destroy = true

  tags {
    Name = "bootstrap_bucket4"
  }
}

# Create Folders and Upload Bootstrap Files
resource "aws_s3_bucket_object" "bootstrap_xml4" {
  bucket = "${aws_s3_bucket.bootstrap_bucket4.id}"
  acl    = "private"
  key    = "config/bootstrap.xml"
  source = "bootstrap_files4/bootstrap.xml"
}

resource "aws_s3_bucket_object" "init-cft_txt4" {
  bucket = "${aws_s3_bucket.bootstrap_bucket4.id}"
  acl    = "private"
  key    = "config/init-cfg.txt"
  source = "bootstrap_files4/init-cfg.txt"
}

resource "aws_s3_bucket_object" "software4" {
  bucket = "${aws_s3_bucket.bootstrap_bucket4.id}"
  acl    = "private"
  key    = "software/"
  source = "/dev/null"
}

resource "aws_s3_bucket_object" "license4" {
  bucket = "${aws_s3_bucket.bootstrap_bucket4.id}"
  acl    = "private"
  key    = "license/authcodes"
  source = "bootstrap_files4/authcodes"
}

resource "aws_s3_bucket_object" "content4" {
  bucket = "${aws_s3_bucket.bootstrap_bucket4.id}"
  acl    = "private"
  key    = "content/"
  source = "/dev/null"
}

/* Roles, ACLs, Permissions, etc... */

resource "aws_iam_role" "bootstrap_role4" {
  name = "ngfw_bootstrap_role4"

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

resource "aws_iam_role_policy" "bootstrap_policy4" {
  name = "ngfw_bootstrap_policy4"
  role = "${aws_iam_role.bootstrap_role4.id}"

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${var.bootstrap_s3bucket4}"
    },
    {
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${var.bootstrap_s3bucket4}/*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "bootstrap_profile4" {
  name = "ngfw_bootstrap_profile4"
  role = "${aws_iam_role.bootstrap_role4.name}"
  path = "/"
}
