


provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}
data "aws_iam_policy_document" "rl_ro" {
    statement {
        sid = "AllowRedlockROExternalAccess"
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            type = "AWS"
            identifiers = ["arn:aws:iam::188619942792:root"]
        }
        condition {
            test = "StringEquals"
            variable = "sts:ExternalId"
            values = ["${var.rl_ro_id}"]
        }
    }
}

resource "aws_iam_policy" "rl_ro_file" {
    name = "RedLock_policy_RO"
    policy = "${file("aws_iam_policy_document_rl_ro.json")}"
}

resource "aws_iam_role" "rl_ro" {
    name = "${var.rl_ro_role_name}"
    assume_role_policy = "${data.aws_iam_policy_document.rl_ro.json}"
    description = "Read only role for RedLock"
}

resource "aws_iam_role_policy_attachment" "rl_secaudit_pol_attach" {
    role = "${aws_iam_role.rl_ro.name}"
    policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "aws_iam_role_policy_attachment" "rl_ro_file_attach" {
    role = "${aws_iam_role.rl_ro.name}"
    policy_arn = "${aws_iam_policy.rl_ro_file.arn}"
}
output "rl_role_output_ExtID" {
    value = "${var.rl_ro_id}"
}
