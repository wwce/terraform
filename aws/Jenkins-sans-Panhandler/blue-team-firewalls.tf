resource "aws_iam_role" "blue-team-bootstraprole" {
  name = "blue-team-bootstraprole-${random_pet.blue_team.id}"

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

resource "aws_iam_role_policy" "blue-team-bootstrappolicy" {
  name = "blue-team-bootstrappolicy-${random_pet.blue_team.id}"
  role = "${aws_iam_role.blue-team-bootstraprole.id}"

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

resource "aws_iam_instance_profile" "blue-team-bootstrapinstanceprofile" {
  name = "blue-team-bootstrapinstanceprofile-${random_pet.blue_team.id}"
  role = "${aws_iam_role.blue-team-bootstraprole.name}"
  path = "/"
}

resource "aws_network_interface" "blue_team_ngfw_mgmt" {
  subnet_id         = "${aws_subnet.blue_team_az1_mgmt.id}"
  security_groups   = ["${aws_security_group.blue_team_open.id}"]
  source_dest_check = false
  private_ips       = ["10.0.0.10"]
  tags = {
    Name = "blue_team_ngfw_mgmt"
  }
}

resource "aws_network_interface" "blue_team_ngfw_untrust" {
  subnet_id         = "${aws_subnet.blue_team_az1_untrust.id}"
  security_groups   = ["${aws_security_group.blue_team_open.id}"]
  source_dest_check = false
  private_ips       = ["10.0.1.10"]
  tags = {
    Name = "blue_team_ngfw_untrust"
  }
}

resource "aws_network_interface" "blue_team_ngfw_trust" {
  subnet_id         = "${aws_subnet.blue_team_az1_trust.id}"
  security_groups   = ["${aws_security_group.blue_team_open.id}"]
  source_dest_check = false
  private_ips       = ["10.0.2.10"]
  tags = {
    Name = "blue_team_ngfw_trust"
  }
}

resource "aws_eip_association" "blue_team_ngfw_untrust-association" {
  network_interface_id = "${aws_network_interface.blue_team_ngfw_untrust.id}"
  allocation_id        = "${aws_eip.blue_team_ngfw_untrust.id}"
}

resource "aws_eip_association" "blue_team_ngfw_trust-association" {
  network_interface_id = "${aws_network_interface.blue_team_ngfw_mgmt.id}"
  allocation_id        = "${aws_eip.blue_team_ngfw_mgmt.id}"
}

#Deploys the firewalls

resource "aws_instance" "pa-vm1" {
  tags = {
    Name = "blue_team_ngfw"
  }

  disable_api_termination = false

  iam_instance_profile = "${aws_iam_instance_profile.blue-team-bootstrapinstanceprofile.name}"
  ebs_optimized        = true
  ami                  = "${var.PANFWRegionMap[var.aws_region]}"
  instance_type        = "m4.xlarge"

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_type           = "gp2"
    delete_on_termination = true
    volume_size           = 60
  }

  key_name   = "${var.aws_key_pair}"
  monitoring = false

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.blue_team_ngfw_mgmt.id}"
  }

  network_interface {
    device_index         = 1
    network_interface_id = "${aws_network_interface.blue_team_ngfw_untrust.id}"
  }

  network_interface {
    device_index         = 2
    network_interface_id = "${aws_network_interface.blue_team_ngfw_trust.id}"
  }

  user_data = "${base64encode(join("", list("vmseries-bootstrap-aws-s3bucket=", "${aws_s3_bucket.bootstrap_bucket.bucket}")))}"

  depends_on = [
    "aws_s3_bucket_object.content",
  ]
}
