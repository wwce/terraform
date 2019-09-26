# Create a BootStrap S3 Bucket

resource "aws_s3_bucket" "bootstrap_bucket3" {
  bucket        = "${var.bootstrap_s3bucket3}"
  acl           = "private"
  force_destroy = true

  tags {
    Name = "bootstrap_bucket3"
  }
}

# Create Folders and Upload Bootstrap Files
resource "aws_s3_bucket_object" "bootstrap_xml3" {
  bucket = "${aws_s3_bucket.bootstrap_bucket3.id}"
  acl    = "private"
  key    = "config/bootstrap.xml"
  source = "bootstrap_files3/bootstrap.xml"
}

resource "aws_s3_bucket_object" "init-cft_txt3" {
  bucket = "${aws_s3_bucket.bootstrap_bucket3.id}"
  acl    = "private"
  key    = "config/init-cfg.txt"
  source = "bootstrap_files3/init-cfg.txt"
}

resource "aws_s3_bucket_object" "software3" {
  bucket = "${aws_s3_bucket.bootstrap_bucket3.id}"
  acl    = "private"
  key    = "software/"
  source = "/dev/null"
}

resource "aws_s3_bucket_object" "license3" {
  bucket = "${aws_s3_bucket.bootstrap_bucket3.id}"
  acl    = "private"
  key    = "license/authcodes"
  source = "bootstrap_files3/authcodes"
}

resource "aws_s3_bucket_object" "content3" {
  bucket = "${aws_s3_bucket.bootstrap_bucket3.id}"
  acl    = "private"
  key    = "content/"
  source = "/dev/null"
}

/* Roles, ACLs, Permissions, etc... */

resource "aws_iam_role" "bootstrap_role3" {
  name = "ngfw_bootstrap_role3"

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

resource "aws_iam_role_policy" "bootstrap_policy3" {
  name = "ngfw_bootstrap_policy3"
  role = "${aws_iam_role.bootstrap_role3.id}"

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${var.bootstrap_s3bucket3}"
    },
    {
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${var.bootstrap_s3bucket3}/*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "bootstrap_profile3" {
  name = "ngfw_bootstrap_profile3"
  role = "${aws_iam_role.bootstrap_role3.name}"
  path = "/"
}
