# Create a BootStrap S3 Bucket

resource "aws_s3_bucket" "bootstrap_bucket" {
  bucket        = "security-framework-${random_pet.blue_team.id}"
  acl           = "private"
  force_destroy = true

  tags = {
    Name = "blue_team"
  }
}

resource "aws_s3_bucket_object" "bootstrap_xml" {
  depends_on = ["aws_s3_bucket.bootstrap_bucket"]
  bucket     = "security-framework-${random_pet.blue_team.id}"
  acl        = "private"
  key        = "config/bootstrap.xml"
  source     = "bootstrap/bootstrap.xml"
}

resource "aws_s3_bucket_object" "init-cft_txt" {
  bucket     = "security-framework-${random_pet.blue_team.id}"
  depends_on = ["aws_s3_bucket.bootstrap_bucket"]
  acl        = "private"
  key        = "config/init-cfg.txt"
  source     = "bootstrap/init-cfg.txt"
}

resource "aws_s3_bucket_object" "software" {
  bucket     = "security-framework-${random_pet.blue_team.id}"
  depends_on = ["aws_s3_bucket.bootstrap_bucket"]
  acl        = "private"
  key        = "software/"
  source     = "/dev/null"
}

resource "aws_s3_bucket_object" "license" {
  bucket     = "security-framework-${random_pet.blue_team.id}"
  depends_on = ["aws_s3_bucket.bootstrap_bucket"]
  acl        = "private"
  key        = "license/"
  source     = "/dev/null"
}

resource "aws_s3_bucket_object" "content" {
  bucket     = "security-framework-${random_pet.blue_team.id}"
  depends_on = ["aws_s3_bucket.bootstrap_bucket"]
  acl        = "private"
  key        = "content/"
  source     = "/dev/null"
}
