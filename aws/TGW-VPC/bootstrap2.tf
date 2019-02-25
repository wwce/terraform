# Create a BootStrap S3 Bucket

resource "aws_s3_bucket" "bootstrap_bucket2" {
  bucket        = "${var.bootstrap_s3bucket2}"
  acl           = "private"
  force_destroy = true

  tags {
    Name = "bootstrap_bucket2"
  }
}

# Create Folders and Upload Bootstrap Files
resource "aws_s3_bucket_object" "bootstrap_xml2" {
  bucket = "${aws_s3_bucket.bootstrap_bucket2.id}"
  acl    = "private"
  key    = "config/bootstrap.xml"
  source = "bootstrap_files2/bootstrap.xml"
}

resource "aws_s3_bucket_object" "init-cft_txt2" {
  bucket = "${aws_s3_bucket.bootstrap_bucket2.id}"
  acl    = "private"
  key    = "config/init-cfg.txt"
  source = "bootstrap_files2/init-cfg.txt"
}

resource "aws_s3_bucket_object" "software2" {
  bucket = "${aws_s3_bucket.bootstrap_bucket2.id}"
  acl    = "private"
  key    = "software/"
  source = "/dev/null"
}

resource "aws_s3_bucket_object" "license2" {
  bucket = "${aws_s3_bucket.bootstrap_bucket2.id}"
  acl    = "private"
  key    = "license/"
  source = "/dev/null"
}

resource "aws_s3_bucket_object" "content2" {
  bucket = "${aws_s3_bucket.bootstrap_bucket2.id}"
  acl    = "private"
  key    = "content/"
  source = "/dev/null"
}

/* Roles, ACLs, Permissions, etc... */

resource "aws_iam_role" "bootstrap_role2" {
  name = "ngfw_bootstrap_role2"

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

resource "aws_iam_role_policy" "bootstrap_policy2" {
  name = "ngfw_bootstrap_policy2"
  role = "${aws_iam_role.bootstrap_role2.id}"

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${var.bootstrap_s3bucket2}"
    },
    {
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${var.bootstrap_s3bucket2}/*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "bootstrap_profile2" {
  name = "ngfw_bootstrap_profile2"
  role = "${aws_iam_role.bootstrap_role2.name}"
  path = "/"
}
