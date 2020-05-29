resource "random_id" "bootstraprole" {
  byte_length = 3
}

resource "random_id" "bootstrappolicy" {
  byte_length = 3
}

resource "random_id" "bootstrapinstanceprofile" {
  byte_length = 3
}

resource "aws_iam_role" "jenkins-bootstraprole" {
  name = "jenkins-bootstraprole-${random_id.bootstraprole.hex}"

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

resource "aws_iam_role_policy" "jenkins-bootstrappolicy" {
  name = "jenkins-bootstrappolicy${random_id.bootstrappolicy.hex}"
  role = "${aws_iam_role.jenkins-bootstraprole.id}"

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.bootstrap_bucket.bucket}"
    },
    {
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${aws_s3_bucket.bootstrap_bucket.bucket}/*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "jenkins-bootstrapinstanceprofile" {
  name = "jenkins-bootstrapinstanceprofile${random_id.bootstrapinstanceprofile.hex}"
  role = "${aws_iam_role.jenkins-bootstraprole.name}"
  path = "/"
}

resource "aws_network_interface" "FW1-MGT" {
  subnet_id         = "${aws_subnet.AZ1-MGT.id}"
  security_groups   = ["${aws_security_group.sgWideOpen.id}"]
  source_dest_check = false
  private_ips       = ["10.0.0.10"]
}

resource "aws_network_interface" "FW1-UNTRUST" {
  subnet_id         = "${aws_subnet.AZ1-UNTRUST.id}"
  security_groups   = ["${aws_security_group.sgWideOpen.id}"]
  source_dest_check = false
  private_ips       = ["10.0.1.10"]
}

resource "aws_network_interface" "FW1-TRUST" {
  subnet_id         = "${aws_subnet.AZ1-TRUST.id}"
  security_groups   = ["${aws_security_group.sgWideOpen.id}"]
  source_dest_check = false
  private_ips       = ["10.0.2.10"]
}

resource "aws_eip_association" "FW1-UNTRUST-Association" {
  network_interface_id = "${aws_network_interface.FW1-UNTRUST.id}"
  allocation_id        = "${aws_eip.FW1-PUB.id}"
}

resource "aws_eip_association" "FW1-TRUST-Association" {
  network_interface_id = "${aws_network_interface.FW1-MGT.id}"
  allocation_id        = "${aws_eip.FW1-MGT.id}"
}

#Deploys the firewalls

resource "aws_instance" "PA-VM1" {
  tags {
    Name = "PA-AZ1"
  }

  disable_api_termination = false

  iam_instance_profile = "${aws_iam_instance_profile.jenkins-bootstrapinstanceprofile.name}"
  ebs_optimized        = true
  ami                  = "${var.PANFWRegionMap[var.aws_region]}"
  instance_type        = "m4.xlarge"

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_type           = "gp2"
    delete_on_termination = true
    volume_size           = 60
  }

  key_name   = "${var.ServerKeyName}"
  monitoring = false

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.FW1-MGT.id}"
  }

  network_interface {
    device_index         = 1
    network_interface_id = "${aws_network_interface.FW1-UNTRUST.id}"
  }

  network_interface {
    device_index         = 2
    network_interface_id = "${aws_network_interface.FW1-TRUST.id}"
  }

  user_data = "${base64encode(join("", list("vmseries-bootstrap-aws-s3bucket=", "${aws_s3_bucket.bootstrap_bucket.bucket}")))}"
}
