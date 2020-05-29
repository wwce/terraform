output "completion" {
  value = "${null_resource.dependency_setter.id}"
}

output "bucket_name" {
  value = "${aws_s3_bucket.bootstrap.id}"
}