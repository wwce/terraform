#************************************************************************************
# CREATE 2 S3 BUCKETS FOR FW1 & FW2
#************************************************************************************
resource "random_string" "randomstring" {
  length      = 25
  min_lower   = 15
  min_numeric = 10
  special     = false
}

resource "aws_s3_bucket" "bootstrap_bucket_fw1" {
  bucket        = "${join("", list(var.bootstrap_s3bucket1_create, "-", random_string.randomstring.result))}"
  acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket" "bootstrap_bucket_fw2" {
  bucket        = "${join("", list(var.bootstrap_s3bucket2_create, "-", random_string.randomstring.result))}"
  acl           = "private"
  force_destroy = true
}


#************************************************************************************
# CREATE FW1 DIRECTORIES & UPLOAD FILES FROM /bootstrap_files/fw1 DIRECTORY
#************************************************************************************
resource "aws_s3_bucket_object" "bootstrap_xml" {
  bucket = "${aws_s3_bucket.bootstrap_bucket_fw1.id}"
  acl    = "private"
  key    = "config/bootstrap.xml"
  source = "bootstrap_files/fw1/bootstrap.xml"
}

resource "aws_s3_bucket_object" "init-cft_txt" {
  bucket = "${aws_s3_bucket.bootstrap_bucket_fw1.id}"
  acl    = "private"
  key    = "config/init-cfg.txt"
  source = "bootstrap_files/fw1/init-cfg.txt"
}

resource "aws_s3_bucket_object" "software" {
  bucket = "${aws_s3_bucket.bootstrap_bucket_fw1.id}"
  acl    = "private"
  key    = "software/"
  source = "/dev/null"
}

resource "aws_s3_bucket_object" "license" {
  bucket = "${aws_s3_bucket.bootstrap_bucket_fw1.id}"
  acl    = "private"
  key    = "license/authcodes"
  source = "bootstrap_files/fw1/authcodes"
}

resource "aws_s3_bucket_object" "content" {
  bucket = "${aws_s3_bucket.bootstrap_bucket_fw1.id}"
  acl    = "private"
  key    = "content/"
  source = "/dev/null"
}


#************************************************************************************
# CREATE FW2 DIRECTORIES & UPLOAD FILES FROM /bootstrap_files/fw2 DIRECTORY
#************************************************************************************
resource "aws_s3_bucket_object" "bootstrap_xml2" {
  bucket = "${aws_s3_bucket.bootstrap_bucket_fw2.id}"
  acl    = "private"
  key    = "config/bootstrap.xml"
  source = "bootstrap_files/fw2/bootstrap.xml"
}

resource "aws_s3_bucket_object" "init-cft_txt2" {
  bucket = "${aws_s3_bucket.bootstrap_bucket_fw2.id}"
  acl    = "private"
  key    = "config/init-cfg.txt"
  source = "bootstrap_files/fw2/init-cfg.txt"
}

resource "aws_s3_bucket_object" "software2" {
  bucket = "${aws_s3_bucket.bootstrap_bucket_fw2.id}"
  acl    = "private"
  key    = "software/"
  source = "/dev/null"
}

resource "aws_s3_bucket_object" "license2" {
  bucket = "${aws_s3_bucket.bootstrap_bucket_fw2.id}"
  acl    = "private"
  key    = "license/authcodes"
  source = "bootstrap_files/fw2/authcodes"
}

resource "aws_s3_bucket_object" "content2" {
  bucket = "${aws_s3_bucket.bootstrap_bucket_fw2.id}"
  acl    = "private"
  key    = "content/"
  source = "/dev/null"
}


#************************************************************************************
# CREATE & ASSIGN IAM ROLE, POLICY, & INSTANCE PROFILE
#************************************************************************************
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
      "Resource": "arn:aws:s3:::${aws_s3_bucket.bootstrap_bucket_fw1.id}"
    },
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.bootstrap_bucket_fw1.id}/*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.bootstrap_bucket_fw2.id}"
    },
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.bootstrap_bucket_fw2.id}/*"
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
