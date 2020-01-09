resource "aws_iam_role" "branch25-fw-bootstraprole" {
  name = "branch25-fw-bootstraprole-${random_id.sdwan.hex}"

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

resource "aws_iam_role_policy" "branch25-fw-bootstrappolicy" {
  name = "branch25-fw-bootstrappolicy-${random_id.sdwan.hex}"
  role = "${aws_iam_role.branch25-fw-bootstraprole.id}"

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.branch25-fw-bootstrap-bucket.bucket}"
    },
    {
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${aws_s3_bucket.branch25-fw-bootstrap-bucket.bucket}/*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "branch25-fw-bootstrapinstanceprofile" {
  name = "branch25-fw-bootstrapinstanceprofile${random_id.sdwan.hex}"
  role = "${aws_iam_role.branch25-fw-bootstraprole.name}"
  path = "/"
}

resource "aws_network_interface" "branch25-fw-mgt" {
  subnet_id         = "${aws_subnet.SD-WAN-MGT.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = true
  private_ips       = ["100.64.0.10"]
}

resource "aws_network_interface" "branch25-fw-wan1" {
  subnet_id         = "${aws_subnet.SD-WAN-WAN1.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.1.10"]
}

resource "aws_network_interface" "branch25-fw-wan2" {
  subnet_id         = "${aws_subnet.SD-WAN-WAN2.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.2.10"]
}

resource "aws_network_interface" "branch25-fw-branch25" {
  subnet_id         = "${aws_subnet.SD-WAN-Branch25.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.25.10"]
}

resource "aws_network_interface" "branch25-fw-mpls" {
  subnet_id         = "${aws_subnet.SD-WAN-MPLS.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.5.10"]
}

resource "aws_eip_association" "branch25-fw-mgt-Association" {
  network_interface_id = "${aws_network_interface.branch25-fw-mgt.id}"
  allocation_id        = "${aws_eip.branch25-fw-mgt.id}"
}

#Deploys the firewalls

resource "aws_instance" "branch25-fw" {
  tags {
    Name = "Branch25-fw"
  }

  disable_api_termination = false

  iam_instance_profile = "${aws_iam_instance_profile.branch25-fw-bootstrapinstanceprofile.name}"
  ebs_optimized        = true
  ami                  = "${var.SD-WAN-BRANCH25-FW}"
  instance_type        = "m5.4xlarge"

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
    network_interface_id = "${aws_network_interface.branch25-fw-mgt.id}"
  }

  network_interface {
    device_index         = 1
    network_interface_id = "${aws_network_interface.branch25-fw-wan1.id}"
  }

  network_interface {
    device_index         = 2
    network_interface_id = "${aws_network_interface.branch25-fw-wan2.id}"
  }

  network_interface {
    device_index         = 3
    network_interface_id = "${aws_network_interface.branch25-fw-branch25.id}"
  }

  network_interface {
    device_index         = 4
    network_interface_id = "${aws_network_interface.branch25-fw-mpls.id}"
  }

#  user_data = "${base64encode(join("", list("vmseries-bootstrap-aws-s3bucket=", "${aws_s3_bucket.branch25-fw-bootstrap-bucket.bucket}")))}"
}
