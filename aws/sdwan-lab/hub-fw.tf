resource "aws_iam_role" "hub-fw-bootstraprole" {
  name = "hub-fw-bootstraprole-${random_id.sdwan.hex}"

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

resource "aws_iam_role_policy" "hub-fw-bootstrappolicy" {
  name = "hub-fw-bootstrappolicy-${random_id.sdwan.hex}"
  role = "${aws_iam_role.hub-fw-bootstraprole.id}"

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.hub-fw-bootstrap-bucket.bucket}"
    },
    {
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${aws_s3_bucket.hub-fw-bootstrap-bucket.bucket}/*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "hub-fw-bootstrapinstanceprofile" {
  name = "hub-fw-bootstrapinstanceprofile${random_id.sdwan.hex}"
  role = "${aws_iam_role.hub-fw-bootstraprole.name}"
  path = "/"
}

resource "aws_network_interface" "hub-fw-mgt" {
  subnet_id         = "${aws_subnet.SD-WAN-MGT.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = true
  private_ips       = ["100.64.0.30"]
}

resource "aws_network_interface" "hub-fw-wan3" {
  subnet_id         = "${aws_subnet.SD-WAN-WAN3.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.3.30"]
}

resource "aws_network_interface" "hub-fw-wan4" {
  subnet_id         = "${aws_subnet.SD-WAN-WAN4.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.4.30"]
}

resource "aws_network_interface" "hub-fw-hub" {
  subnet_id         = "${aws_subnet.SD-WAN-Hub.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.254.30"]
}

resource "aws_network_interface" "hub-fw-mpls" {
  subnet_id         = "${aws_subnet.SD-WAN-MPLS.id}"
  security_groups   = ["${aws_security_group.allow-all.id}"]
  source_dest_check = false
  private_ips       = ["100.64.5.30"]
}

resource "aws_eip_association" "hub-fw-mgt-Association" {
  network_interface_id = "${aws_network_interface.hub-fw-mgt.id}"
  allocation_id        = "${aws_eip.hub-fw-mgt.id}"
}

#Deploys the firewalls

resource "aws_instance" "hub-fw" {
  tags {
    Name = "hub-fw"
  }

  disable_api_termination = false

  iam_instance_profile = "${aws_iam_instance_profile.hub-fw-bootstrapinstanceprofile.name}"
  ebs_optimized        = true
  ami                  = "${var.PANFWRegionMap[var.aws_region]}"
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
    network_interface_id = "${aws_network_interface.hub-fw-mgt.id}"
  }

  network_interface {
    device_index         = 1
    network_interface_id = "${aws_network_interface.hub-fw-wan3.id}"
  }

  network_interface {
    device_index         = 2
    network_interface_id = "${aws_network_interface.hub-fw-wan4.id}"
  }

  network_interface {
    device_index         = 3
    network_interface_id = "${aws_network_interface.hub-fw-hub.id}"
  }

  network_interface {
    device_index         = 4
    network_interface_id = "${aws_network_interface.hub-fw-mpls.id}"
  }

  user_data = "${base64encode(join("", list("vmseries-bootstrap-aws-s3bucket=", "${aws_s3_bucket.hub-fw-bootstrap-bucket.bucket}")))}"
}
