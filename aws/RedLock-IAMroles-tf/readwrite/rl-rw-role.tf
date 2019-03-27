


provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}
data "aws_iam_policy_document" "rl_rw" {
    statement {
        sid = "AllowRedlockRWExternalAccess"
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            type = "AWS"
            identifiers = ["arn:aws:iam::188619942792:root"]
        }
        condition {
            test = "StringEquals"
            variable = "sts:ExternalId"
            values = ["${var.rl_rw_id}"]
        }
    }
}

resource "aws_iam_policy" "rl_ro_file" {
    name = "RedLock_policy_ro"
    policy = "${file("aws_iam_policy_document_rl_ro.json")}"
}

resource "aws_iam_policy" "rl_remediation_file" {
    name = "RedLock_policy_remediation"
    policy = "${file("aws_iam_policy_remediation.json")}"
}

resource "aws_iam_role" "rl_rw" {
    name = "${var.rl_rw_role_name}"
    assume_role_policy = "${data.aws_iam_policy_document.rl_rw.json}"
    description = "Read write role for RedLock"
}

resource "aws_iam_role_policy_attachment" "rl_secaudit_pol_attach" {
    role = "${aws_iam_role.rl_rw.name}"
    policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "aws_iam_role_policy_attachment" "rl_ro_file_attach" {
    role = "${aws_iam_role.rl_rw.name}"
    policy_arn = "${aws_iam_policy.rl_ro_file.arn}"
}

resource "aws_iam_role_policy_attachment" "rl_remediation_file_attach" {
    role = "${aws_iam_role.rl_rw.name}"
    policy_arn = "${aws_iam_policy.rl_remediation_file.arn}"
}
output "rl_role_output_arn" {
  value = "${var.rl_rw_id}"
}
